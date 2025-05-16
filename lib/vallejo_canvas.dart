import 'package:cars_simulation/ball.dart';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:cars_simulation/car.dart';
import 'package:flutter/material.dart';

class VallejoCanvas extends StatefulWidget {
  const VallejoCanvas({super.key});

  @override
  State<VallejoCanvas> createState() => _VallejoCanvasState();
}

class _VallejoCanvasState extends State<VallejoCanvas> {
  double maxWidth = 0;
  double maxHeight = 0;

  final ballController = CanvasElementController(initPos: Offset(0, 0), codeName: 'ball');
  final ballController2 = CanvasElementController(initPos: Offset(0, 0), codeName: 'ball');

  final carController = CanvasElementController(initPos: Offset(100, 100), codeName: 'green_car');
  final carController2 = CanvasElementController(initPos: Offset(200, 150), codeName: 'blue_car');
  final carController3 = CanvasElementController(initPos: Offset(300, 200), codeName: 'red_car');

  Future<void> startLoop() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 20));
      ballController.drawNextFrame(maxWidth, maxHeight);
      ballController2.drawNextFrame(maxWidth, maxHeight);
      carController.drawNextFrame(maxWidth, maxHeight);
      carController2.drawNextFrame(maxWidth, maxHeight);
      carController3.drawNextFrame(maxWidth, maxHeight);
    }
  }

  @override
  void initState() {
    startLoop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      maxHeight = constraints.maxHeight;
      maxWidth = constraints.maxWidth;

      return Stack(
        children: [
          Ball(
            ballController: ballController,
            color: Colors.red,
          ),
          Ball(
            ballController: ballController2,
            color: Colors.blue,
            size: 40,
          ),
          Car(carController: carController, color: Colors.green, codeName: 'verde'),
          Car(carController: carController2, color: Colors.blue, codeName: 'azul'),
          Car(carController: carController3, color: Colors.red, codeName: 'rojo'),
        ],
      );
    });
  }
}
