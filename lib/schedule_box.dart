import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'schedule.dart';
import 'schedule_painter.dart';
import 'scheduleView.dart';

class ScheduleBox extends StatefulWidget {

  double left, top, width, height;
  String name;
  late _ScheduleBoxState boxState;
  ScheduleViewState schView;
  Color color = Colors.redAccent;

  ScheduleBox(double left, double top, double width, double height, String name, ScheduleViewState schView):
        left = left, top = top, width = width, height = height, name = name, schView = schView {}

  @override
  _ScheduleBoxState createState() {
    boxState = _ScheduleBoxState(this);
    return boxState;
  }
}


class _ScheduleBoxState extends State<ScheduleBox> {

  ScheduleBox box;
  double grabberRadius = 10;
  bool isEditMode = false;

  _ScheduleBoxState(ScheduleBox box): box = box {}

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /*
      Body
       */
      Positioned(left: box.left,
          top:box.top, child: GestureDetector(child: Container(
              width:box.width, height:box.height, color: box.color, child: Center(child:Text(box.name)
          )),
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isEditMode = !isEditMode;
                  if (isEditMode) {
                    box.schView.editedBox = box;
                  } else {
                    //box.schView
                  }
                  box.schView.setState(() {
                    box.schView.txt.text = box.name;
                    box.schView.editing = isEditMode;
                  });
                });
              })),
      /*
      Top Grabber
       */
      Positioned(left: (2*box.left+box.width)/2-grabberRadius, top: box.top-grabberRadius, child:
      Visibility(visible: isEditMode, child:
      GestureDetector(
          child: Container(
            width:2*grabberRadius, height:2*grabberRadius, decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.4),
              shape: BoxShape.circle
          ),
          )
      ))
      ),

      /*
      Bottom Grabber
       */
      Positioned(left: (2*box.left+box.width)/2-grabberRadius, top: box.top+box.height-grabberRadius, child:
      Visibility(visible: isEditMode, child:
      GestureDetector(
          child: Container(
            width:2*grabberRadius, height:2*grabberRadius, decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.4),
              shape: BoxShape.circle
          ),
          )
      ))
      )
    ]);
  }
}