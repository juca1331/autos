import 'package:cars_simulation/ball.dart';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:cars_simulation/car.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class VallejoCanvas extends StatefulWidget {
  const VallejoCanvas({super.key});

  @override
  State<VallejoCanvas> createState() => _VallejoCanvasState();
}

class _VallejoCanvasState extends State<VallejoCanvas> {
  double maxWidth = 0;
  double maxHeight = 0;
  final List<CanvasElementController> canvasElements = [
    CanvasElementController(initPos: Offset(0, 0), codeName: 'red_ball'),
    CanvasElementController(initPos: Offset(0, 0), codeName: 'blue_ball'),
    CanvasElementController(initPos: Offset(100, 100), codeName: 'green_car'),
  ];

  CanvasElementController? controllerByCodeName(String codeName) {
    return canvasElements
        .firstWhereOrNull((element) => element.codeName == codeName);
  }

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
      for (var element in canvasElements) {
        element.drawNextFrame(maxWidth, maxHeight);
      }
      detectCollisions(canvasElements);
    }
  }

  @override
  void initState() {
    startLoop().then(
      (value) {},
    );
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
            ballController: controllerByCodeName('red_ball')!,
            color: Colors.red,
          ),
          Ball(
            ballController: controllerByCodeName('blue_ball')!,
            color: Colors.blue,
            size: 40,
          ),
          Car(
            carController: controllerByCodeName('green_car')!,
            color: Colors.green,
          )
        ],
      );
    });
  }
}
