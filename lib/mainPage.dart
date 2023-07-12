import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'friendPage.dart';
import 'scheduleView.dart';

//바탕이 되는 페이지
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

//바탕이 되는 페이지
class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; //현재 BottomNavigationBar에서 선택된 페이지 Index

  //표시할 페이지 목록
  static const List<Widget> _widgetOptions = <Widget>[
    ScheduleView(),
    FriendPage(),
    Text('Team'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), //BottomNavigationBar에서 선택된 Index를 불러옴
      ),
      bottomNavigationBar: BottomNavigationBar(
        //BottomNavigationBar의 Item - 각각의 Item들을 선택하여 어떤 페이지를 선택할까 고름
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_rounded),
            label: 'Friend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Team',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  //BottomNavigationBar에서 Item 클릭 시의 효과
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}