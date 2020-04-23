import 'package:circle_bar_chart/SectionData.dart';
import 'package:flutter/material.dart';

class Data {
  final double radiusText;

  final Color centerSpaceColor;


  final double startDegreeOffset;
  final List<SectionData> sections;
  double get sumValue => sections
      .map((data) => data.value)
      .reduce((first, second) => first + second);
  Data({
    List<SectionData> sections,
    double centerSpaceRadius,
    Color centerSpaceColor,
    double startDegreeOffset,
  })  : sections = sections ?? const [],
        radiusText = centerSpaceRadius ?? double.nan,
        centerSpaceColor = centerSpaceColor ?? Colors.transparent,
        startDegreeOffset = startDegreeOffset ?? 0;
}
