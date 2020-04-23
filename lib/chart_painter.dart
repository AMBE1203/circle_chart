import 'dart:math' as math;

import 'package:circle_bar_chart/section_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data.dart';
import 'hex_color.dart';

const double _degrees2Radians = math.pi / 180.0;

class DemoChart extends StatefulWidget {
  @override
  _DemoChartState createState() => _DemoChartState();
}

class _DemoChartState extends State<DemoChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width),
          painter: ChartPainter(
              Data(centerSpaceRadius: 100, sections: showingSections())),
        ),
      ),
    );
  }

  List<SectionData> showingSections() {
    return List.generate(2, (i) {
      final double fontSize = 14;
      final double radius = 60;
      switch (i) {
        case 0:
          return SectionData(
            value: 74,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: HexColor('#696969')),
          );
        case 1:
          return SectionData(
            value: 26,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: HexColor('#696969')),
          );
        default:
          return null;
      }
    });
  }
}

class ChartPainter extends CustomPainter {
  Paint _sectionPaint, _centerSpacePaint, _shadowPaint;
  Data data;

  ChartPainter(this.data);
  double radians(double degrees) => degrees * _degrees2Radians;

  @override
  void paint(Canvas canvas, Size size) {
    _sectionPaint = Paint()..style = PaintingStyle.stroke;
    _shadowPaint = Paint()..style = PaintingStyle.stroke;

    _centerSpacePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.sections[0].radius / 3
      ..color = HexColor('#6F6F6F');

    final List<double> sectionsAngle =
        _calculateSectionsAngle(data.sections, data.sumValue);

    _drawCenterSpace(canvas, size);
    _drawSections(canvas, size, sectionsAngle);
    _drawTexts(canvas, size);
  }

  List<double> _calculateSectionsAngle(
      List<SectionData> sections, double sumValue) {
    return sections.map((section) {
      return 360 * (section.value / sumValue);
    }).toList();
  }

  void _drawCenterSpace(Canvas canvas, Size viewSize) {
    final double centerX = viewSize.width / 2;
    final double centerY = viewSize.height / 2;

    canvas.drawCircle(
        Offset(centerX, centerY),
        _calculateCenterRadius(viewSize, data.radiusText) +
            (data.sections[0].radius * 0.5),
        _centerSpacePaint);
  }

  void _drawSections(Canvas canvas, Size viewSize, List<double> sectionsAngle) {
    canvas.saveLayer(
        Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), Paint());
    final Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = 0;

    for (int i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      final sectionDegree = sectionsAngle[i];

      final rect = Rect.fromCircle(
        center: center,
        radius: _calculateCenterRadius(viewSize, data.radiusText) +
            (section.radius / 2),
      );

      final gradient = new SweepGradient(
        startAngle: 0,
        endAngle: 7 * math.pi / 2,
        tileMode: TileMode.repeated,
        colors: [HexColor('#FFC555'), HexColor('#F49220')],
      );
      _sectionPaint.color = section.color; // todo set color
      _sectionPaint.strokeWidth = section.radius;
      _sectionPaint..shader = gradient.createShader(rect); //todo set gradient

      _shadowPaint.strokeWidth = section.radius;
      _shadowPaint..color = HexColor('#000000').withOpacity(0.3);
      _shadowPaint..maskFilter = MaskFilter.blur(BlurStyle.outer, 10);

      final double startAngle = tempAngle;
      final double sweepAngle = sectionDegree;
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle - 5),
        false,
        _shadowPaint,
      );
      canvas.drawArc(
        rect,
        radians(startAngle),
        radians(sweepAngle - 5),
        false,
        _sectionPaint,
      );

      tempAngle += sweepAngle;
    }
    canvas.restore();
  }

  void _drawTexts(Canvas canvas, Size viewSize) {
    final Offset center = Offset(viewSize.width / 2, viewSize.height / 2);

    double tempAngle = data.startDegreeOffset;
    for (int i = 0; i < data.sections.length; i++) {
      final SectionData section = data.sections[i];
      final double startAngle = tempAngle;
      final double sweepAngle = 360 * (section.value / data.sumValue);
      final double sectionCenterAngle = startAngle + (sweepAngle / 2);
      final Offset sectionCenterOffset = center +
          Offset(
            math.cos(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.radiusText) +
                    (section.radius * 0.5)),
            math.sin(radians(sectionCenterAngle)) *
                (_calculateCenterRadius(viewSize, data.radiusText) +
                    (section.radius * 0.5)),
          );

      final TextSpan span = TextSpan(
          style: section.titleStyle,
          text: '${(section.value * 100 / data.sumValue).toStringAsFixed(2)}%');
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          textScaleFactor: 1);
      tp.layout();
      tp.paint(
          canvas, sectionCenterOffset - Offset(tp.width / 2, tp.height / 2));

      tempAngle += sweepAngle;
    }
  }

  double _calculateCenterRadius(Size viewSize, double r) {
   return r;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
