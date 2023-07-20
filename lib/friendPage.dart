import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'main.dart';

//Friend Item을 클릭 하였을 때 표시할 페이지
class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

//Friend Item을 클릭 하였을 때 표시할 페이지
class _FriendPageState extends State<FriendPage> {
  final _authentication = FirebaseAuth.instance;
  User ? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('친구 목록',
                  style: TextStyle(color: Colors.black, fontSize: 24)),
            ), //친구 목록 Text 표시
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.add_box),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return const AddFriendDialog();
                      });
                },
              ), //플러스 Icon을 선택하여 친구 추가
            )
          ]),
          Expanded(
            child: ListView.builder(
              //추가된 친구들의 목록을 보여줌
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              itemCount: context.watch<FriendList>().friendList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  //TextButton 하나가 친구 하나의 이름을 표시
                  title: Text(
                    context.watch<FriendList>().friendList[index],
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<FriendList>().removeFriend(
                          context.read<FriendList>().friendList[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//친구 추가 방법을 선택할 Dialog를 띄움
class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({Key? key}) : super(key: key);

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () {},
          child: const Text('링크 보내기'),
        ),
        SimpleDialogOption(
          //ID로 친구 추가 하는 방법
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return const AddFriendWithIdDialog();
                });
          },
          child: const Text('ID로 친구 추가'),
        ),
      ],
    );
  }
}

//ID로 친구 추가하는 Dialog, textfield에 ID를 입력함
class AddFriendWithIdDialog extends StatefulWidget {
  const AddFriendWithIdDialog({Key? key}) : super(key: key);

  @override
  State<AddFriendWithIdDialog> createState() => _AddFriendWithIdDialogState();
}

class _AddFriendWithIdDialogState extends State<AddFriendWithIdDialog> {
  TextEditingController friendController = TextEditingController(); //키보드 입력창

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('친구의 ID를 입력하세요'),
      //텍스트 입력창
      content: TextField(
        controller: friendController,
        decoration: const InputDecoration(hintText: 'Enter friend ID'),
      ),
      actions: <Widget>[
        TextButton(
          //취소 버튼
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        TextButton(
          //추가 버튼
          onPressed: () {
            //입력된 텍스트를 불러와서 friendList에 추가
            if (friendController.text.isNotEmpty &&
                !context
                    .read<FriendList>()
                    .friendList
                    .contains(friendController.text)) {
              context.read<FriendList>().addFriend(friendController.text);
              friendController.clear();
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
