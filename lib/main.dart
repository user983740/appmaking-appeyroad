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

class MyColors {
  static const Color orange = Color(0xffffb7b2);
  static const Color green = Color(0xffb5ead7);
}

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

  //Init to use kakaotalk
  KakaoSdk.init(nativeAppKey: '5097fd4d40b188803d6ef1c71aa88d3f');

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
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
            colorScheme: const ColorScheme(primary: Color(0xff919191), onPrimary: Colors.white,
                background: Colors.white, onBackground: Color(0xff565656),
                surface: Color(0xfff5f5f5), onSurface: Color(0xff919191),
                secondary: Color(0xffff9aa2), onSecondary: Colors.white,
                error: Colors.black, onError: Colors.white,
                brightness: Brightness.light

            ),  textTheme: const TextTheme(
            labelSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
            labelMedium: TextStyle(fontSize: 17, color: Colors.white)

        )
        ),
        /** */
        home: const LogInPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}