//import 'dart:html';
//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../main.dart';
import 'schedule.dart';
import 'schedule_box.dart';
import 'schedule_painter.dart';
import 'week_chip.dart';


import 'custom_icons.dart';


class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  ScheduleViewState createState() => ScheduleViewState(2023, 1, 1, 1);
}
enum EditItem {changeColor, changeTime, setPrivacy}
/*
===============================================================================
SCHEDULE VIEW STATE
===============================================================================
 */
class ScheduleViewState extends State<ScheduleView> {

  /* Format */
  int hoursOfDay = 10; //range of schedule
  int startHour = 9; //starting hour of schedule
  int subCellMin = 30;

  /* Current Date */
  late int year;
  late int month; //starts from 1
  int week, currentWeek; //starts from 1
  late List<int> weekArrangement;

  /* Schedule Data */
  Schedule schedule = Schedule();
  List<ScheduleItem> schItems = <ScheduleItem>[];
  List<List<ScheduleItem>> schItemsSorted = <List<ScheduleItem>>[];

  /* States */
  bool creating = false;
  bool editing = false;
  late ScheduleBox editedBox;

  /* Grid Painter */
  int previewEndLimit = 600; //TODO change this
  late SchedulePainter painter;
  bool firstTime = true;
  final _counter = ValueNotifier<int>(0);


  /* Dimensions */
  double width = 0, height = 0;
  static const hourAxisWidth = 25.0;
  static const iconInkSize = 28.0;
  static const iconSize = 18.0;
  static const iconInkRoundness = 12.0;
  static const customIconSize = 12.0;
  static const topBarHeight =40.0;

  /// Find out how the weeks are arranged(how much weeks, length of first and last week in days etc.) in the [month] of the [year].
  /// For example, to get the week arrangement of December 2002, do:
  /// ```dart
  /// _getWeekArrangement(2002, 12)
  /// ```
  /// Returns [[startTail, numOfFullWeeks, numOfWeeks, endTail]]
  ///
  /// [startTail]: Length of first week (can be shorter than 7)
  ///
  /// [numOfFullWeeks]: Number of weeks that are 7 days long
  ///
  /// [numOfWeeks]: Number of weeks
  ///
  /// [endTail]: Length of last week (can be shorter than 7)
  static List<int> _getWeekArrangement(int year, int month) {
    int firstDOW = DateTime(year, month, 1).weekday;
    DateTime lastDayOfMonth = DateTime(year, month+1, 0);
    int lastDOW = lastDayOfMonth.weekday; //works perfectly
    if (lastDOW == 7) lastDOW = 0;
    int startTail = (7-firstDOW);
    int endTail = (lastDOW+1);
    int numOfFullWeeks = (lastDayOfMonth.day - startTail - endTail)~/7;
    int numOfWeeks = numOfFullWeeks + (startTail>0 ? 1 : 0) + (endTail>0 ? 1 : 0);
    return [startTail, numOfFullWeeks, numOfWeeks, endTail];
  }


  void _setYearAndMonth(int year, int month) {
    this.year = year;
    this.month = month;
    weekArrangement = _getWeekArrangement(year, month);
  }

  void _moveWeek(bool next) {

  }

  ScheduleViewState(year, month, this.week, this.currentWeek) {
    _setYearAndMonth(year, month);
    for (int i = 0; i < 7; i++) {
      schItemsSorted.add(<ScheduleItem>[]);
    }
  }

/*
===============================================================================
WIDGET BUILD
===============================================================================
 */

  @override
  Widget build(BuildContext context) {

    ColorScheme c = Theme.of(context).colorScheme;

    GestureDetector gestureDetector = GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapDown(_counter, painter, details.localPosition.dx, details.localPosition.dy);
      },
      onPanStart: (DragStartDetails details) {
        _tapDown(_counter, painter, details.localPosition.dx, details.localPosition.dy);
      },
      onTapUp: (TapUpDetails details) {
        _tapUp(_counter, painter);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _counter.value++;
        painter.previewEndRow = (details.localPosition.dy ~/ painter.subCellHeight + 1).clamp(painter.previewStartRow+1, previewEndLimit);
      },
      onPanEnd: (DragEndDetails details) {
        _tapUp(_counter, painter);
      },
    );

    painter = SchedulePainter(_counter, Theme.of(context), this, hourAxisWidth, startHour, hoursOfDay, subCellMin);

    double weekdayLabelHeight = 25;
    double cellMargin = 3;

    List<Widget> weekdayLabels = <Widget>[];
    List<String> weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    weekdayLabels.add(// 20%
        Container(width:hourAxisWidth, height:weekdayLabelHeight,  alignment: Alignment.bottomRight, color: Theme.of(context).colorScheme.surface, padding: EdgeInsets.all(cellMargin),)
    );

    for (int i = 0; i < 7; i++) {
      weekdayLabels.add(
        Expanded(
          flex: 1, // 20%
          child:     Container(height:weekdayLabelHeight, alignment: Alignment.bottomRight, color: Theme.of(context).colorScheme.surface, padding: EdgeInsets.all(cellMargin),
              child: Text(weekdays[i], style: Theme.of(context).textTheme.labelSmall))
        )
        );
    }

    /*
    Build schedule boxes (selectable widgets)
     */
    List<Widget> schBoxes = <Widget>[];
    for (ScheduleItem item in schItems) {
      schBoxes.add(ScheduleBox(item, this));
    }

    child: return Column(
      children: [Container(height:topBarHeight, margin: EdgeInsets.only(bottom: 10), child: Row(children: [

        Container( decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            backgroundBlendMode: BlendMode.multiply), height: double.infinity,
            child: Row(children: [
              IconButton(icon:Icon(Icons.keyboard_arrow_left, size: iconSize,), color: Theme.of(context).colorScheme.primary, onPressed: () {setState(() {_moveWeek(false);});},),
              WeekChip(year, month, weekArrangement, currentWeek),
              IconButton(icon:Icon(Icons.keyboard_arrow_right, size:iconSize), color: Theme.of(context).colorScheme.primary, onPressed: () {setState(() {_moveWeek(true);});},)
            ],)),
        Expanded(
            child:Container(
                height:double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    backgroundBlendMode: BlendMode.multiply),
                margin: EdgeInsets.only(left:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Ink(
                        width: iconInkSize, height: iconInkSize,
                        decoration: ShapeDecoration(
                            color: c.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconInkRoundness))
                        ), child: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {  }, color:c.onPrimary, iconSize: iconSize)),
                    Ink(
                      width: iconInkSize, height: iconInkSize,
                      decoration: ShapeDecoration(
                          color: c.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconInkRoundness))
                      ), child: PopupMenuButton<EditItem>(
                      iconSize: iconSize,
                      color: c.onPrimary,
                      initialValue: EditItem.changeColor,
                      // Callback that sets the selected popup menu item.
                      onSelected: (EditItem item) {
                        setState(() {

                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<EditItem>>[
                        const PopupMenuItem<EditItem>(
                          value: EditItem.changeColor,
                          child: Text('Change Color'),
                        ),
                        const PopupMenuItem<EditItem>(
                          value: EditItem.changeTime,
                          child: Text('Change Time'),
                        ),
                        const PopupMenuItem<EditItem>(
                          value: EditItem.setPrivacy,
                          child: Text('Set Privacy'),
                        ),
                      ],
                    ),),
                    Ink(
                        width: iconInkSize, height: iconInkSize,
                        decoration: ShapeDecoration(
                            color: c.secondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconInkRoundness))
                        ), child: IconButton(icon: const Icon(CustomIcons.grid_one), onPressed: () {  }, color:c.onSecondary, iconSize: customIconSize,)),
                    Ink(
                        width: iconInkSize, height: iconInkSize,
                        decoration: ShapeDecoration(
                            color: MyColors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconInkRoundness))
                        ), child: IconButton(icon: const Icon(CustomIcons.grid_two), onPressed: () {  }, color:c.onSecondary, iconSize: customIconSize,)),
                    Ink(
                        width: iconInkSize, height: iconInkSize,
                        decoration: ShapeDecoration(
                            color: MyColors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconInkRoundness))
                        ), child: IconButton(icon: const Icon(CustomIcons.grid_four), onPressed: () {  }, color:c.onSecondary, iconSize: customIconSize)),
                  ].map((widget) => Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: widget,
                  )).toList(),
                )
            )
        )
      ],)),

        //[Container(width: weekdayLabelHeight, color: Theme.of(context).colorScheme.surface, padding: EdgeInsets.all(cellMargin))]

        //Day of Week Labels
        Row(children: weekdayLabels),

      //Grid
        Flexible(child: Stack(children: [
          //Drawing area
          Container(color: Theme.of(context).colorScheme.surface, child:  CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: painter
          )),

        //Gesture detection area
        Row(children: [Container(height:double.infinity, width:hourAxisWidth), Expanded(
          child: Stack(children: <Widget>[gestureDetector]+schBoxes,)
       )])
        ]))
      //Flexible(child: Container( color: Theme.of(context).colorScheme.surface, child: Stack(children:stackChildren)))
          , ]
    );

  }

  void _changeColor(Color color) {
    setState(() {
      editedBox.boxState.setState(() {
        editedBox.color = color;
      });
    });
  }

  void _tapDown(ValueNotifier<int> _counter, SchedulePainter painter, double x, double y) {
    _counter.value++;

      creating = true;
      painter.previewDayOfWeek = (x) ~/ painter.cellWidth;
      painter.previewStartRow = y ~/ painter.subCellHeight;
      painter.previewEndRow = painter.previewStartRow + 1;
      //determine preview end limit
      previewEndLimit = 5000000;
      for (ScheduleItem item in schItemsSorted[painter.previewDayOfWeek]) {
        print("startMin: " + item.startMin.toString());
        int boxStartRow = (item.startMin-startHour*60) ~/ subCellMin;
        if (boxStartRow >= painter.previewStartRow + 1 && boxStartRow < previewEndLimit) {
          previewEndLimit = boxStartRow;
        }
      }
      painter.preview = true;

  }

  void _tapUp(ValueNotifier<int> _counter, SchedulePainter painter) {
    _counter.value++;
    creating = false;
    //TODO register schedule item
    setState(() {
      List<int> mins = painter.previewToMins();
      //ScheduleItem schItem = ScheduleItem("Test", painter.previewDayOfWeek, mins[0], mins[1]);
      ScheduleItem schItem = ScheduleItem.fromPreview("name", painter.previewStartRow, painter.previewEndRow, painter.previewDayOfWeek, startHour, subCellMin);
      //ScheduleBox box = ScheduleBox(schItem, this);
      //schBoxes.add(box);
      //schBoxesSorted[painter.previewDayOfWeek].add(box);
      schItems.add(schItem);
      schItemsSorted[painter.previewDayOfWeek].add(schItem);
    });
    painter.preview = false;
  }



}