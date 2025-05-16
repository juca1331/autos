import 'dart:math';

import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:flutter/material.dart';



class Ball extends StatefulWidget {
  const Ball({
    super.key,
    required this.ballController,
    required this.color,
    this.size = 30,
  });

  final CanvasElementController ballController;
  final Color color;
  final double size;

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  double xpos = 0;
  double ypos = 0;

  bool toRight = true;
  bool toBottom = true;

  double horizontalVelocity = 0;
  double verticalVelocity = 0;
  int pathFrames = 0;

  @override
  void initState() {
    xpos = widget.ballController.initPos.dx;
    ypos = widget.ballController.initPos.dy;
    widget.ballController.getPosition=(){
      return Offset(xpos, ypos);
    };
    widget.ballController.getSize=(){
      return Size(widget.size, widget.size);
    };
    widget.ballController.drawNextFrame = (maxWidth, maxHeight) {
      setState(() {
        pathFrames++;
        if (pathFrames >= widget.size) {
          pathFrames = 0;
          final random = Random();
          horizontalVelocity = random.nextInt(10) + 2;
          verticalVelocity = random.nextInt(7) + 2;
        }

        if (toRight) {
          xpos += horizontalVelocity;
        } else {
          xpos -= horizontalVelocity;
        }

        if (toBottom) {
          ypos += verticalVelocity;
        } else {
          ypos -= verticalVelocity;
        }

        if (xpos + widget.size > maxWidth) {
          toRight = false;
          xpos = maxWidth - widget.size;
        }

        if (xpos < 0) {
          toRight = true;
        }

        if (ypos + widget.size > maxHeight) {
          toBottom = false;
          ypos = maxHeight - widget.size;
        }

        if (ypos < 0) {
          toBottom = true;
        }
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ypos,
      left: xpos,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
