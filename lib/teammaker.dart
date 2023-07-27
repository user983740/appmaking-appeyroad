import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMaker extends StatefulWidget {
  const TeamMaker({super.key});

  @override
  State<TeamMaker> createState() => _TeamMakerState();
}

GlobalKey<FormState> myFormKey = new GlobalKey();

class _TeamMakerState extends State<TeamMaker> {
  final _teamData = FirebaseFirestore.instance;

  String teamName = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedEndDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 5)));

  String startTime = '';
  String endTime = '';
  double _currentHourSliderValue = 2;
  double _currentLeastMemberSliderValue = 1;
  List<String> addedFriendsList = ['추가하세요', '친구를'];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> friendsList = [
      'Flutter',
      'Node.js',
      'React Native',
      'Java',
      'Docker',
      'MySQL'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: friendsList);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        addedFriendsList = results;
      });
    }
  }

  void showLightTimePicker() {
    showDialog(
        context: context,
        builder: (_) => FromToTimePicker(
              onTab: (from, to) {
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
                          onChanged: (value) {
                            teamName = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '팀 이름',
                          ),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        _teamData.collection('teams').add({
                          "name": teamName,
                          "startDate": startDate.millisecondsSinceEpoch,
                          "endDate": endDate.millisecondsSinceEpoch,
                          "startTime": startTime,
                          "endTime": endTime,
                          "hour": _currentHourSliderValue,
                          "leastMember": _currentLeastMemberSliderValue,
                          "addedFriends": addedFriendsList
                        });

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
                  FloatingActionButton(
                    onPressed: () {
                      showCustomDateRangePicker(
                        context,
                        dismissible: true,
                        minimumDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 30)),
                        endDate: endDate,
                        startDate: startDate,
                        backgroundColor: Colors.white,
                        onApplyClick: (start, end) {
                          setState(() {
                            endDate = end;
                            startDate = start;
                            formattedStartDate =
                                DateFormat('yyyy-MM-dd').format(start);
                            formattedEndDate =
                                DateFormat('yyyy-MM-dd').format(end);
                          });
                        },
                        onCancelClick: () {},
                      );
                    },
                    tooltip: 'choose date Range',
                    child: const Icon(Icons.calendar_today_outlined,
                        color: Colors.white),
                  ),
                  if (startDate != null)
                    SizedBox(
                        child:
                            Text('${formattedStartDate} - $formattedEndDate'))
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
                            Text('팀원'),
                            SizedBox(width: 30),
                            Text(
                              '${addedFriendsList.length} 명',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: _showMultiSelect, child: Icon(Icons.add))
                      ],
                    ),
                  ),
                  Wrap(
                    children: addedFriendsList
                        .map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('친구 추가'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListBody(
                children: widget.items
                    .map((item) => CheckboxListTile(
                          value: _selectedItems.contains(item),
                          title: Text(item),
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (isChecked) =>
                              _itemChange(item, isChecked!),
                        ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                  TextButton(
                    onPressed: _cancel,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
