### ./lib/canvas_element_controller.dart
```dart
import 'package:flutter/material.dart';

class CanvasElementController {
  CanvasElementController({
    required this.initPos,
    required this.codeName,
  });

  final Offset initPos;
  final String codeName;

  Function(double maxWidth, double maxHeight) drawNextFrame =
      (maxWidth, maxHeight) {};

  Offset Function()getPosition=() {
    return Offset.zero;
  };

  Size Function()getSize=() {
    return Size.zero;
  };
}```

### ./lib/main.dart
```dart
import 'package:cars_simulation/vallejo_canvas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VallejoCanvas(
        
      )
    );
  }
}

```

### ./lib/ball.dart
```dart
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
```

### ./lib/car.dart
```dart
import 'dart:math';
import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Car extends StatefulWidget {
  const Car({
    super.key,
    required this.carController,
    required this.color,
    required this.codeName, // parámetro obligatorio agregado
    this.size = 30,
  });

  final CanvasElementController carController;
  final Color color;
  final String codeName; // nuevo parámetro
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

    widget.carController.getPosition = () {
      return Offset(xpos, ypos);
    };

    widget.carController.getSize = () {
      return Size(widget.size, widget.size);
    };

    widget.carController.drawNextFrame = (maxWidth, maxHeight) {
      setState(() {
        pathFrames++;
        if (pathFrames >= 50) {
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
    };
  }

  void _randomizeDirection() {
    final random = Random();
    velocity = (random.nextDouble() * 5) + 2;
    angleDeg = random.nextDouble() * 360;
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
```

### ./lib/vallejo_canvas.dart
```dart
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
```

