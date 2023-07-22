import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'schedule_view.dart';


/// The custom painter which is in charge of drawing the grid.
class SchedulePainter extends CustomPainter {

  static const DAYS_OF_WEEK = 7;

  int _hoursOfDay = 10; //range of schedule
  int _startHour = 9; //starting hour of schedule
  int _subCellDivision = 2; //how much sub-cells are in an hour (ex. 2 = 30 min)
  int _subCellMin = 30;

  /* Dimensions */
  late double cellWidth, cellHeight, subCellHeight;
  double hourAxisWidth;
  double width = 0;
  double height = 0;
  static const HOUR_AXIS_WIDTH_RATIO = 0.3;

  /* Preview */
  bool preview = false;
  int previewDayOfWeek = 0;
  int previewStartRow = 0;
  int previewEndRow = 0;

  /* Aesthetics */
  ThemeData themeData;
  late Paint cellPaint, subCellPaint, previewPaint;
  late TextStyle hourAxisLabelStyle;

  /* Structural */
  ScheduleViewState schView;

  SchedulePainter(Listenable redraw, ThemeData this.themeData, ScheduleViewState this.schView, double this.hourAxisWidth,
      int this._startHour, int this._hoursOfDay, int this._subCellMin): super(repaint: redraw){
    cellPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = themeData.colorScheme.background
      ..strokeWidth = 1;

    subCellPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade500
      ..strokeWidth = 0.2;

    previewPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = themeData.colorScheme.secondary.withOpacity(0.4);

    hourAxisLabelStyle = const TextStyle(
        color: Colors.grey,
        fontSize:8
    );
  }

  void changeSubCellDivision(int div) {
    _subCellDivision = div;
    updateSubCellHeight();
  }

  void updateSubCellHeight() {
    subCellHeight = cellHeight / _subCellDivision;
  }

  void _drawText(Canvas canvas, x, y, text) {
    final textSpan = TextSpan(
        text: text,
        style: themeData.textTheme.labelSmall
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
      cellWidth = (width-hourAxisWidth)/DAYS_OF_WEEK;
      cellHeight = height / _hoursOfDay;
      //this.hourAxisWidth = cellWidth * HOUR_AXIS_WIDTH_RATIO;
      updateSubCellHeight();
    }

    for (int i = 0; i < _hoursOfDay; i++) {
      //draws hour axis guidelines
      double y = rToY(i);
      canvas.drawLine(Offset(0, y), Offset(hourAxisWidth, y), cellPaint);
      //draws hour axis labels
      _drawText(canvas, hourAxisWidth-2, y+2, (i+_startHour).toString());

      for (int j = 0; j < DAYS_OF_WEEK; j++) {
        //draw cells
        canvas.drawRect(Rect.fromLTWH(
            dOWToX(j), y, cellWidth,
            cellHeight), cellPaint);
      }
    }

    //draw subcells
    /*
    int subRowNum = hoursOfDay * subCellDivision;
    for (int i = 0; i < subRowNum; i++) {
      for (int j = 0; j < DAYS_OF_WEEK; j++) {
        canvas.drawRect(Rect.fromLTWH(cellWidth*j+hourAxisWidth, subCellHeight*i, cellWidth, subCellHeight), subCellPaint);
      }
    } */

    if (preview) {
      double left = dOWToX(previewDayOfWeek);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(left, sRToY(previewStartRow), left+cellWidth, sRToY(previewEndRow)), Radius.circular(15)), previewPaint);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    //throw UnimplementedError();
    return false;
  }

  List<int> previewToMins() {
    return [((_startHour + previewStartRow/_subCellDivision)*60).toInt(), ((_startHour + previewEndRow/_subCellDivision)*60).toInt()];
  }

}