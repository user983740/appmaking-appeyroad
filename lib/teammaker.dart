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
  double _currentHourSliderValue = 2;
  double _currentLeastMemberSliderValue = 1;

  final List<String> addedFriendsList = <String>[
    'friend1',
    'friend2',
    'friend3',
    'friend4'
  ];

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
      body: SingleChildScrollView(
        child: Padding(
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
                          labelText: '$startTime 시 ~ $endTime 시',
                        ),
                      ))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 15),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock),
                        Text('약속 시간(hour)'),
                        SizedBox(width: 30),
                        Text(
                          '$_currentHourSliderValue 시간',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _currentHourSliderValue,
                    max: 10,
                    divisions: 10,
                    label: _currentHourSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentHourSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 15),
                    child: Row(
                      children: [
                        Icon(Icons.people),
                        Text('최소 포함 인원'),
                        SizedBox(width: 30),
                        Text(
                          '$_currentLeastMemberSliderValue 명',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _currentLeastMemberSliderValue,
                    max: addedFriendsList.length.toDouble(),
                    divisions: addedFriendsList.length,
                    label: _currentLeastMemberSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentLeastMemberSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people),
                            Text('팀원 추가하기'),
                            SizedBox(width: 30),
                            Text(
                              '${addedFriendsList.length} 명',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddFriends()),
                                ),
                            child: const Text('Add friends'))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: addedFriendsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text('${addedFriendsList[index]}'),
                            onTap: () {
                              print('${addedFriendsList[index]} selected');
                            },
                          );
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
