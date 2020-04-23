import 'package:flutter/material.dart';

class SectionData {
   final double value;

  final Color color;

  final double radius;


  final TextStyle titleStyle;



 SectionData({
    double value,
    Color color,
    double radius,
    TextStyle titleStyle,
    String title,
  })  : value = value ?? 10,
        color = color ?? Colors.red,
        radius = radius ?? 40,
        titleStyle = titleStyle ??
            const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
       
}
