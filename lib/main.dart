import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'logInPage.dart';
import 'firebase_options.dart';

class FriendList with ChangeNotifier {
  List<String> _friendList = <String>[];

  List<String> get friendList => _friendList;

  void addFriend(String friendId) {
    _friendList.add(friendId);
    notifyListeners();
  }

  void removeFriend(String friendId) {
    _friendList.remove(friendId);
    notifyListeners();
  }
}

//App의 구동
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  KakaoSdk.init(
    nativeAppKey: '5097fd4d40b188803d6ef1c71aa88d3f',
    javaScriptAppKey: '091e1a7886e05138feff81cdfd19a4bc',
  );
  String? url = await receiveKakaoScheme();
  kakaoSchemeStream.listen((url) {
    var customUrlScheme = url;
  }, onError: (e) {
    // 에러 상황의 예외 처리 코드를 작성합니다.
  });
  runApp(const MyApp());
}


//가장 기본 페이지
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FriendList(),
        ),
      ],
      child: MaterialApp(
        title: 'Calendar App',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const LogInPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}