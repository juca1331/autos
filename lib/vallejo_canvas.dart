import 'package:cars_simulation/ball.dart';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:cars_simulation/car.dart';
import 'package:cars_simulation/gas_station.dart';
import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class VallejoCanvas extends StatefulWidget {
  const VallejoCanvas({super.key});

  @override
  State<VallejoCanvas> createState() => _VallejoCanvasState();
}

class _VallejoCanvasState extends State<VallejoCanvas> {
  double maxWidth = 700;
  double maxHeight = 700;

  Map<String, CanvasElementController> controllers = {
    /* 'red_ball':
        CanvasElementController(initPos: Offset(300, 300), codeName: 'red_ball'),
    'blue_ball':
        CanvasElementController(initPos: Offset(100, 0), codeName: 'blue_ball'),*/
    'green_car':
        CanvasElementController(initPos: Offset(0, 100), codeName: 'green_car'),
    'blue_car':
        CanvasElementController(initPos: Offset(40, 0), codeName: 'blue_car'),
    'red_car':
        CanvasElementController(initPos: Offset(200, 0), codeName: 'red_car'),
    'gas_station': CanvasElementController(
        initPos: Offset(double.infinity, double.infinity),
        codeName: 'gas_station')
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
          print(
              '🎯 Colisión detectada entre el elemento ${a.codeName} y ${b.codeName}');
          a.bounce(b);
          b.bounce(a);
          for (var i = 0; i < 2; i++) {
            a.drawNextFrame(maxWidth, maxHeight, true);
            b.drawNextFrame(maxWidth, maxHeight, true);
          }

          // Aquí puedes realizar alguna acción: detener movimiento, cambiar dirección, etc.
        }
      }
    }
  }

  Future<void> startLoop() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 20));
      for (var element in controllers.values) {
        element.drawNextFrame(maxWidth, maxHeight, false);
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
    return Zoom(
      maxZoomWidth: maxWidth,
      maxZoomHeight: maxHeight,
      child: Stack(
        children: [
          /*Ball(
              ballController: controllers['red_ball']!,
              color: Colors.red,
            ),
            Ball(
              ballController: controllers ['blue_ball']!,
              color: Colors.blue,
              size: 40,
            ),*/
          Car(
            carController: controllers['green_car']!,
            gasController: controllers['gas_station']!,
            color: Colors.green,
          ),
          Car(
            carController: controllers['blue_car']!,
            gasController: controllers['gas_station']!,
            color: Colors.blue,
          ),
          Car(
            carController: controllers['red_car']!,
            gasController: controllers['gas_station']!,
            color: Colors.red,
          ),
          GasStation(controller: controllers['gas_station']!),
        ],
      ),
    );
  }
}
