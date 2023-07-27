import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';

import 'package:flutter/material.dart';
import 'teamMaker.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: FriendsList(),
    );
  }
}

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final List<String> friendsList = <String>[
    'friend1',
    'friend2',
    'friend3',
    'friend4'
  ];
  final List<String> teamList = <String>['Team1', 'Team2', 'Team3', 'Team4'];

  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: TabBar(
              indicator: BoxDecoration(color: Colors.blue[300]),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: "Team"),
                Tab(text: "Friends"),
              ],
            ),
            body: TabBarView(children: <Widget>[
              ListsWidget(
                lists: teamList,
                subjective: '팀',
              ),
              ListsWidget(
                lists: friendsList,
                subjective: '친구',
              ),
            ])),
    );
  }
}

// ignore: must_be_immutable
class ListsWidget extends StatefulWidget {
  ListsWidget({super.key, required this.lists, this.subjective});

  final List<String> lists;
  var subjective;

  @override
  State<ListsWidget> createState() => _ListsWidgetState();
}

class _ListsWidgetState extends State<ListsWidget> {
  Map teamDialogContents = {
    'title': '팀 만들기',
    'contents': '친구 추가한 후 스케줄을 추가하세요!',
    'confirmBtn': '팀 만들기'
  };
  Map friendsDialogContents = {
    'title': '친구 추가하기',
    'contents': '친구 추가한 후 스케줄을 추가하세요!',
    'confirmBtn': '확인'
  };
  @override
  Widget build(BuildContext context) {
    //팝업창 만드는 함수
    Future<void> _dialogBuilder(
        BuildContext context, titleContent, contents, confirmBtn) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${titleContent}'),
            content: Text('${contents}'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('나가기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text('${confirmBtn}'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamMaker()),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: SearchAnchor.bar(
            barHintText: '${widget.subjective} 찾기',
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<Widget>.generate(
                5,
                (int index) {
                  return ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text('Initial list item $index'),
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('teams').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: widget.lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text('${widget.lists[index]}'),
                        onTap: () {
                          print('${snapshot.data}');
                        },
                      );
                    });
              }),
        ),
        Expanded(
          child: FloatingActionButton(
              onPressed: () {
                if (widget.subjective == '팀') {
                  _dialogBuilder(
                      context,
                      teamDialogContents['title'],
                      teamDialogContents['contents'],
                      teamDialogContents['confirmBtn']);
                } else {
                  _dialogBuilder(
                      context,
                      friendsDialogContents['title'],
                      friendsDialogContents['contents'],
                      friendsDialogContents['confirmBtn']);
                }
              },
              child: Icon(Icons.add)),
        )
      ],
    );
  }
}
