import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'schedule.dart';
import 'schedule_box.dart';
import 'schedule_painter.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  ScheduleViewState createState() => ScheduleViewState();
}

class ScheduleViewState extends State<ScheduleView> {

  Schedule schedule = Schedule();
  bool creating = false;
  bool editing = false;
  late ScheduleBox editedBox;
  int previewEndLimit = 600; //TODO change this

  List<ScheduleBox> schBoxes = <ScheduleBox>[];
  List<List<ScheduleBox>> schBoxesSorted = <List<ScheduleBox>>[];

  late TextField nameEdit;
  var txt = TextEditingController();

  //final _counter = ValueNotifier<int>(0);
  //late SchedulePainter painter = SchedulePainter(_counter);

  ScheduleViewState() {
    for (int i = 0; i < 7; i++) {
      schBoxesSorted.add(<ScheduleBox>[]);
    }
    nameEdit = TextField(onChanged: (String s) {
      setState(() {
        editedBox.name = s;
        editedBox.boxState.setState(() {
        });
      });
    }, controller: txt,);
  }

  @override
  Widget build(BuildContext context) {
    //Counter that notifies the SchedulePainter to redraw

    final _counter = ValueNotifier<int>(0);
    SchedulePainter painter = new SchedulePainter(_counter);

    List<Widget> stackChildren =
    [
      GestureDetector(
        child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: painter
        ),
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
      )
    ];

    stackChildren = stackChildren + schBoxes;

    return Scaffold(
      body: Column(
          children: [
            Container(height: 50, color: Colors.white10, child: Visibility(visible: editing, child:
            Row(children: [
              Container(width:200, padding: EdgeInsets.all(5), child: nameEdit),
              OutlinedButton(onPressed: () {
                setState(() {
                  schBoxes.remove(editedBox);
                  editing = false;
                });
              }, child: Text("Delete"),),
              Spacer(),
              ElevatedButton(onPressed: () {_changeColor(Colors.redAccent);}, child: Text(""), style: ElevatedButton.styleFrom( primary: Colors.redAccent )),
              ElevatedButton(onPressed: () {_changeColor(Colors.orangeAccent);}, child: Text(""), style: ElevatedButton.styleFrom( primary: Colors.orangeAccent )),
              ElevatedButton(onPressed: () {_changeColor(Colors.yellowAccent);}, child: Text(""), style: ElevatedButton.styleFrom( primary: Colors.yellowAccent )),
              ElevatedButton(onPressed: () {_changeColor(Colors.greenAccent);}, child: Text(""), style: ElevatedButton.styleFrom( primary: Colors.greenAccent )),
              ElevatedButton(onPressed: () {_changeColor(Colors.blueAccent);}, child: Text(""), style: ElevatedButton.styleFrom( primary: Colors.blueAccent ))
            ]))
            ),
            Container(height: 600, child: Stack(children:stackChildren),)
          ]
      ),
    );

    return Stack(
        children: stackChildren);
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
    if (painter.hourAxisWidth < x) {
      creating = true;
      painter.previewDayOfWeek = (x - painter.hourAxisWidth) ~/ painter.cellWidth;
      painter.previewStartRow = y ~/ painter.subCellHeight;
      painter.previewEndRow = painter.previewStartRow + 1;
      //determine preview end limit
      previewEndLimit = 500;
      for (ScheduleBox box in schBoxesSorted[painter.previewDayOfWeek]) {
        int boxStartRow = box.top ~/ painter.subCellHeight;
        if (boxStartRow >= painter.previewStartRow + 1 && boxStartRow < previewEndLimit) {
          previewEndLimit = boxStartRow;
        }
      }
      painter.preview = true;
    }
  }

  void _tapUp(ValueNotifier<int> _counter, SchedulePainter painter) {
    _counter.value++;
    creating = false;
    //TODO register schedule item
    setState(() {
      ScheduleBox box = ScheduleBox(painter.dOWToX(painter.previewDayOfWeek), painter.sRToY(painter.previewStartRow),
          painter.cellWidth, painter.subCellHeight*(painter.previewEndRow-painter.previewStartRow), "Test", this);
      schBoxes.add(box);
      schBoxesSorted[painter.previewDayOfWeek].add(box);
    });
    painter.preview = false;
  }
}
