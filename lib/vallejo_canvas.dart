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

  Map<String, CanvasElementController> controllers = {
    'red_ball':
        CanvasElementController(initPos: Offset(0, 0), codeName: 'red_ball'),
    'blue_ball':
        CanvasElementController(initPos: Offset(0, 0), codeName: 'blue_ball'),
    'green_car':
        CanvasElementController(initPos: Offset(0, 0), codeName: 'green_car'),
    'blue_car':
        CanvasElementController(initPos: Offset(0, 0), codeName: 'blue_car'),
    'red_car':
        CanvasElementController(initPos: Offset(0, 0), codeName: 'red_car'),
  };

  
  void detectCollisions(List<CanvasElementController> controllers) {
    for (int i = 0; i < controllers.length; i++) {
      for (int j = i + 1; j < controllers.length; j++) {
        final a = controllers[i];
        final b = controllers[j];

        final rectA = Rect.fromLTWH(
          a.getPosition().dx,
          a.getPosition().dy,
          a.getSize().width,
          a.getSize().height,
        );

        final rectB = Rect.fromLTWH(
          b.getPosition().dx,
          b.getPosition().dy,
          b.getSize().width,
          b.getSize().height,
        );

        if (rectA.overlaps(rectB)) {
          print('🎯 Colisión detectada entre el elemento ${a.codeName} y ${b.codeName}');
          // Aquí puedes realizar alguna acción: detener movimiento, cambiar dirección, etc.
        }
      }
    }
  }

  Future<void> startLoop() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 20));
      for (var element in controllers.values) {
        element.drawNextFrame(maxWidth,maxHeight);
      }
      detectCollisions(controllers.values.toList());
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
            ballController: controllers['red_ball']!,
            color: Colors.red,
          ),
          Ball(
            ballController: controllers ['blue_ball']!,
            color: Colors.blue,
            size: 40,
          ),
          Car(
              carController: controllers['green_car']!,
              color: Colors.green,
              codeName: 'verde'),
          Car(
              carController: controllers['blue_car']!,
              color: Colors.blue,
              codeName: 'azul'),
          Car(
              carController: controllers['red_car']!,
              color: Colors.red,
              codeName: 'rojo'),
        ],
      );
    });
  }
}
