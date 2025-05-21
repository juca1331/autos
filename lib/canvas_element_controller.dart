import 'package:flutter/material.dart';

class CanvasElementController {
  CanvasElementController({
    required this.initPos,
    required this.codeName,
  });

  final Offset initPos;
  final String codeName;

  Function(double maxWidth, double maxHeight,bool force) drawNextFrame =
      (maxWidth, maxHeight,force) {};

  Offset Function() getPosition = () {
    return Offset.zero;
  };

  Size Function() getSize = () {
    return Size.zero;
  };

  void Function(CanvasElementController controller) bounce = (_) {};
}
