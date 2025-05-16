import 'dart:math';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class Car extends StatefulWidget {
  const Car({
    super.key,
    required this.carController,
    required this.color,
    this.size = 30,
  });

  final CanvasElementController carController;
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

  @override
  void initState() {
    super.initState();

    xpos = widget.carController.initPos.dx;
    ypos = widget.carController.initPos.dy;

    _randomizeDirection();

    widget.carController.getPosition=(){
      return Offset(xpos, ypos);
    };

    widget.carController.getSize=(){
      return Size(widget.size, widget.size);
    };

    widget.carController.drawNextFrame = (maxWidth, maxHeight) {
      setState(() {
        pathFrames++;
        if (pathFrames >= 50) {
          pathFrames = 0;
          _randomizeDirection();
        }

        // Movimiento
        double radians = angleDeg * (pi / 180);
        xpos += cos(radians) * velocity;
        ypos += sin(radians) * velocity;

        // Rebotes
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
    };
  }

  void _randomizeDirection() {
    final random = Random();
    velocity = (random.nextDouble() * 5) + 2; // entre 2 y 7
    angleDeg = random.nextDouble() * 360;     // entre 0 y 360 grados
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ypos,
      left: xpos,
      child: SizedBox(
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
    );
  }
}
