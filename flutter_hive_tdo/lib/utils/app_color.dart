import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color.fromRGBO(2, 26, 42, 1);
  static const List<BoxShadow> neoBoxShadow = [
    BoxShadow(
      color: Colors.white24,
      offset: Offset(1, 1),
      blurRadius: 2,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.75),
      offset: Offset(-2, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      offset: Offset(2, 2),
      blurRadius: 4,
      blurStyle: BlurStyle.outer,
    ),
    BoxShadow(
      color: Colors.white54,
      offset: Offset(-2, -2),
      blurRadius: 4,
      blurStyle: BlurStyle.outer,
    ),
  ];
}