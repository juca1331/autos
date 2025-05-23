import 'dart:math';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Car extends StatefulWidget {
  const Car({
    super.key,
    required this.carController,
    required this.gasController,
    required this.color,
    this.size = 30,
  });

  final CanvasElementController carController;
  final CanvasElementController gasController;
  final Color color;

  final double size;

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  double xpos = 0;
  double ypos = 0;

  double velocity = 0;
  double angleDeg = 0;

  int pathFrames = 0;

  int pathSize = 50;

  bool isOn = true;

  double gasPercentage = 100;

  double gasLimit = 40;

  @override
  void initState() {
    super.initState();

    xpos = widget.carController.initPos.dx;
    ypos = widget.carController.initPos.dy;

    _randomizeDirection();

    widget.carController.bounce = (controller) {
      if (controller.codeName == 'red_ball' ||
          controller.codeName.contains('car')) {
        setState(() {
          //  isOn = false;
        });
      } else if (controller.codeName == 'blue_ball') {
        setState(() {
          isOn = true;
        });
      } else if (controller.codeName == 'gas_station') {
        gasPercentage = 100;
      }
      angleDeg = (angleDeg + 180) % 360;
    };

    widget.carController.getPosition = () {
      return Offset(xpos, ypos);
    };

    widget.carController.getSize = () {
      return Size(widget.size, widget.size);
    };

    widget.carController.drawNextFrame = (maxWidth, maxHeight, force) {
      if (isOn || force) {
        setState(() {
          pathFrames++;
          if (gasPercentage > 0.0) {
            gasPercentage = max(0, gasPercentage - 0.1);
          } else {
            isOn = false;
          }

          if (pathFrames >= pathSize) {
            pathFrames = 0;

            _randomizeDirection();
          }

          double radians = angleDeg * (pi / 180);
          xpos += cos(radians) * velocity;
          ypos += sin(radians) * velocity;

          bool rebounded = false;

          if (xpos + widget.size > maxWidth) {
            xpos = maxWidth - widget.size;
            angleDeg = 180 - angleDeg;
            rebounded = true;
          } else if (xpos < 0) {
            xpos = 0;
            angleDeg = 180 - angleDeg;
            rebounded = true;
          }

          if (ypos + widget.size > maxHeight) {
            ypos = maxHeight - widget.size;
            angleDeg = -angleDeg;
            rebounded = true;
          } else if (ypos < 0) {
            ypos = 0;
            angleDeg = -angleDeg;
            rebounded = true;
          }

          if (rebounded) {
            angleDeg %= 360;
          }
        });
      }
    };
  }

  double angleBetweenOffsets(Offset a, Offset b) {
    final delta = b - a;
    final radians = atan2(delta.dy, delta.dx);
    return radians * 180 / pi;
  }

  void _randomizeDirection() {
    final random = Random();

    velocity = (random.nextDouble() * 5) + 2;
    pathSize = random.nextInt(70) + 30;

    if (gasPercentage < gasLimit) {
      angleDeg = angleBetweenOffsets(
        Offset(xpos, ypos),
        widget.gasController.getPosition(),
      );
    } else {
      angleDeg = random.nextDouble() * 360;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ypos,
      left: xpos,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isOn = !isOn;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: widget.color)),
              width: widget.size,
              height: widget.size,
              child: Transform.rotate(
                angle: angleDeg * pi / 180,
                child: SvgPicture.asset(
                  'assets/car.svg',
                  colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '%${gasPercentage.toStringAsFixed(2)}',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 10,
                    color: widget.color,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
