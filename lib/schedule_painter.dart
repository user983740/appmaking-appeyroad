import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'scheduleView.dart';

class SchedulePainter extends CustomPainter {

  static const DAYS_OF_WEEK = 7;

  int hoursOfDay = 10; //range of schedule
  int startHour = 9; //starting hour of schedule
  int subCellDivision = 2; //how much sub-cells are in an hour (ex. 2 = 30 min)

  static const HOUR_AXIS_WIDTH_RATIO = 0.3;

  late double cellWidth, cellHeight, subCellHeight;
  double hourAxisWidth = 0;

  double width = 0;
  double height = 0;

  late Paint cellPaint, subCellPaint, previewPaint;
  late TextStyle hourAxisLabelStyle;

  bool preview = false;

  int previewDayOfWeek = 0;
  int previewStartRow = 0;
  int previewEndRow = 0;


  SchedulePainter(Listenable redraw): super(repaint: redraw){
    cellPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 3;

    subCellPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 1.5;

    previewPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.pinkAccent.withOpacity(0.4);

    hourAxisLabelStyle = const TextStyle(
        color: Colors.grey,
        fontSize:8
    );
  }

  void changeSubCellDivision(int div) {
    subCellDivision = div;
    updateSubCellHeight();
  }

  void updateSubCellHeight() {
    subCellHeight = cellHeight / subCellDivision;
  }

  void _drawText(Canvas canvas, x, y, text) {
    const textStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter()
      ..text = textSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.right
      ..layout();

    final realX = x - textPainter.width;
    final realY = y;
    final offset = Offset(realX, realY);

    textPainter.paint(canvas, offset);
  }

  double dOWToX(int dayOfWeek) {
    return hourAxisWidth + dayOfWeek * cellWidth;
  }

  double sRToY(int subrow) {
    return subrow * subCellHeight;
  }

  double rToY(int row) {
    return row * cellHeight;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //TODO find out how to detect widget resize events, then remove size compare mechanism
    if (size.width != width || size.height != height) {
      width = size.width;
      height = size.height;
      cellWidth = width / (DAYS_OF_WEEK + HOUR_AXIS_WIDTH_RATIO);
      cellHeight = height / hoursOfDay;
      this.hourAxisWidth = cellWidth * HOUR_AXIS_WIDTH_RATIO;
      updateSubCellHeight();
    }

    for (int i = 0; i < hoursOfDay; i++) {
      //draws hour axis guidelines
      double y = rToY(i);
      canvas.drawLine(Offset(0, y), Offset(hourAxisWidth, y), cellPaint);
      //draws hour axis labels
      _drawText(canvas, hourAxisWidth-2, y+2, (i+startHour).toString());

      for (int j = 0; j < DAYS_OF_WEEK; j++) {
        //draw cells
        canvas.drawRect(Rect.fromLTWH(
            dOWToX(j), y, cellWidth,
            cellHeight), cellPaint);
      }
    }

    //draw subcells
    int subRowNum = hoursOfDay * subCellDivision;
    for (int i = 0; i < subRowNum; i++) {
      for (int j = 0; j < DAYS_OF_WEEK; j++) {
        canvas.drawRect(Rect.fromLTWH(cellWidth*j+hourAxisWidth, subCellHeight*i, cellWidth, subCellHeight), subCellPaint);
      }
    }

    if (preview) {
      double left = dOWToX(previewDayOfWeek);
      canvas.drawRect(Rect.fromLTRB(left, sRToY(previewStartRow), left+cellWidth, sRToY(previewEndRow)), previewPaint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    //throw UnimplementedError();
    return false;
  }

}