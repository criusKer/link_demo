import 'package:flutter/material.dart';
import 'package:link_demo/position_model.dart';

/// create by crius on 2020/11/6
/// email:criusker@163.com

class LinePainter extends CustomPainter {

  final List<PositionModel> lines;

  LinePainter({this.lines});

  var line = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.blue
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    if(lines.length == 0) return;
    print("线的数量：${lines.length}");
    for(PositionModel draw in lines){
      canvas.drawLine(Offset(draw.startX, draw.startY- 80.0), Offset(draw.endX,draw.endY - 80.0), line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}