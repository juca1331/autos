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
}