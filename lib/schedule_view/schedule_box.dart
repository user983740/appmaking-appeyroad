//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'schedule.dart';
import 'schedule_painter.dart';
import 'schedule_view.dart';

class ScheduleBox extends StatefulWidget {

  late _ScheduleBoxState boxState;
  ScheduleViewState schView;
  Color color = Colors.redAccent;

  ScheduleItem schItem;

  ScheduleBox(ScheduleItem schItem, ScheduleViewState schView):
        schItem = schItem, schView = schView {}

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

  void setEditMode(bool isEditMode) {
    setState(() {
      this.isEditMode = isEditMode;
    });
    box.schView.editing = isEditMode;
    if (isEditMode)
      box.schView.editedBox = box;
  }

  @override
  Widget build(BuildContext context) {

    ScheduleItem item = box.schItem;
    ScheduleViewState schView = box.schView;
    SchedulePainter painter = box.schView.painter;

    double widthFactor = 1/7;
    double heightFactor = (item.endMin - item.startMin)/(schView.hoursOfDay*60);

    //The body of the box. The fractionally aligned sized box aligns itself in the parent (schedule grid) based on ratios.
    FractionallyAlignedSizedBox body = FractionallyAlignedSizedBox(
        Container(
          margin: EdgeInsets.all(1),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.secondary,
          ), alignment: Alignment.topLeft,
          child: Text(box.schItem.name, style: Theme.of(context).textTheme.labelMedium),
        ),
        item.dayOfWeek/7,
        (item.startMin/60-schView.startHour)/schView.hoursOfDay,
        widthFactor, heightFactor);

    //Gesture detector that wraps the body. It will detect whether the user tapped the body so the schedule box can transition into edit mode, making the grabbers visible.
    Widget bodyGestureDetector = GestureDetector(
        child: body,
        onTapDown: (TapDownDetails details) {
          /*
            Change the edit state of this and/or the currently edited box depending on the situation.
            If this box is in edit mode, turn it off.
            If this box is not in edit mode, either just turn on this box's edit mode if no other box is in edit mode,
            or turn the other box's edit mode off first if another box was already in edit mode.
            Also tell the schedule view whether an item is under edit mode or not as a result of the tap action.
             */

          if (isEditMode) {
            setEditMode(false);
          } else {
            if (schView.editing) {

              schView.editedBox.boxState.setState(() {
                schView.editedBox.boxState.setEditMode(false);
              });
            }
            setEditMode(true);
          }
        });

    return bodyGestureDetector;

    /*
    return Stack(children: [
      /*
      Body
       */
      Positioned(left: r.left,
        top:r.top, child: GestureDetector(child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Theme.of(context).colorScheme.secondary,
              ),
            width:r.width, height:r.height, child: Center(child:Text(box.schItem.name)
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
                box.schView.txt.text = box.schItem.name;
                box.schView.editing = isEditMode;
              });
            });
          })),
      /*
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


    */
    ]);

    */
  }
}

class FractionallyAlignedSizedBox extends StatelessWidget {
  FractionallyAlignedSizedBox(
      this.child,
      this.leftFactor,
      this.topFactor,
      this.widthFactor,
      this.heightFactor,
      );

  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double heightFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double dx = 0;
    double dy = 0;
    double width = widthFactor;
    double height = heightFactor;

    if (widthFactor < 1 && heightFactor < 1) {
      dx = leftFactor / (1 - widthFactor);
      dy = topFactor / (1 - heightFactor);
    }

    return Align(
      alignment: FractionalOffset(
        dx,
        dy,
      ),
      child: FractionallySizedBox(
        widthFactor: width,
        heightFactor: height,
        child: child,
      ),
    );
  }
}


