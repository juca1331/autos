import 'package:cars_simulation/canvas_element_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GasStation extends StatefulWidget {
  const GasStation({super.key, required this.controller});

  final CanvasElementController controller;

  @override
  State<GasStation> createState() => _GasStationState();
}

class _GasStationState extends State<GasStation> {
  double xpos = 0;
  double ypos = 0;

  @override
  void initState() {
    widget.controller.bounce = (controller) {};

    widget.controller.getSize = () {
      return Size(50, 50);
    };

    widget.controller.getPosition = () {
      return Offset(xpos, ypos);
    };

    widget.controller.drawNextFrame = (maxWidth, maxHeight, _) {
      setState(() {
        xpos = maxWidth - 50;
        ypos = maxHeight - 50;
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ypos,
      left: xpos,
      child: SvgPicture.asset(
        'assets/gas_station.svg',
        width: 50,
        height: 50,
      ),
    );
  }
}
