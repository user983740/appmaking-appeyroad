import 'dart:ui';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';

import 'package:flutter/material.dart';

class TeamMaker extends StatefulWidget {
  const TeamMaker({super.key});

  @override
  State<TeamMaker> createState() => _TeamMakerState();
}

class _TeamMakerState extends State<TeamMaker> {
  DateTimeRange? myDateRange;

  String startTime = 'from';
  String endTime = 'to'
      '';

  double _currentSliderValue = 0.0;
  String? _sliderStatus;

  void showLightTimePicker() {
    showDialog(
        context: context,
        builder: (_) => FromToTimePicker(
              onTab: (from, to) {
                print('from $from to $to');
                setState(() {
                  startTime = from.hour.toString();
                  endTime = to.hour.toString();
                });
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 만들기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 100,
                      height: 40,
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '팀 이름',
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Complete'),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text('날짜 선택'),
                ),
                DateRangeField(
                    enabled: true,
                    initialValue: DateTimeRange(
                        start: DateTime.now(),
                        end: DateTime.now().add(Duration(days: 5))),
                    decoration: InputDecoration(
                      labelText: 'Date Range',
                      prefixIcon: Icon(Icons.date_range),
                      hintText: 'Please select a start and end date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.start.isBefore(DateTime.now())) {
                        return 'Please enter a later start date';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        myDateRange = value!;
                      });
                    }),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text('시간 선택'),
                ),
                SizedBox(
                    width: 430,
                    child: TextField(
                      onTap: () => showLightTimePicker(),
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '$startTime to $endTime',
                      ),
                    ))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text('약속 시간'),
                ),
                //  CupertinoSliderApp()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class CupertinoSliderApp extends StatelessWidget {
//   const CupertinoSliderApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CupertinoApp(
//       theme: CupertinoThemeData(brightness: Brightness.light),
//       home: CupertinoSliderExample(),
//     );
//   }
// }