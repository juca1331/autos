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
// manana 3:30
//tarea: hacer que la gasolina baje 

