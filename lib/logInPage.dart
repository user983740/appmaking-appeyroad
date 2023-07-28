import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart' as KakaoUser;

import 'main.dart';
import 'mainPage.dart';
import 'signUpPage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  bool _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            //배경
            Positioned(
              top: 0,
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: Container(
                  padding: const EdgeInsets.only(top: 90, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Your Calendar',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right:0,
              child: TextButton(    //앱 테스트를 위한 임시 로그인 스킵
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MainPage();
                  }));
                },
                child: Text('Skip Login', style: TextStyle(color: Colors.black, fontSize: 30)),
                style: TextButton.styleFrom(side: BorderSide(style: BorderStyle.solid)),
              ),
            ),
            //텍스트 입력

            /// Original ID&PW text fields made by Minseok Seo
            /*
            Positioned(
              top: 180,
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 240,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const Text('LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                key: const ValueKey(1),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'email을 입력하세요';
                                  }
                                  else if(!value.contains('@') || !value.contains('com')){
                                    return 'email 형식이 올바르지 않습니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userEmail = value!;
                                },
                                onChanged: (value) {
                                  _userEmail = value;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                  ),
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              TextFormField(
                                obscureText: _isObscure,
                                key: const ValueKey(2),
                                validator: (value) {
                                  RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?!.*[ㄱ-ㅎㅏ-ㅣ가-힣]).+$');
                                  if(value!.isEmpty){
                                    return '비밀번호를 입력하세요';
                                  }
                                  else if (value.length < 8) {
                                    return '비밀번호는 8글자 이상이어야 합니다.';
                                  }
                                  else if (!passwordRegex.hasMatch(value)){
                                    return '비밀번호는 영어와 숫자를 모두 포함해야 하고 한글이 포함되면 안됩니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userPassword = value!;
                                },
                                onChanged: (value) {
                                  _userPassword = value;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleObscure,
                                    child: Icon(_isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                  ),
                                  labelText: 'password',
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            */

            ///입력 버튼(right arrow)

            /*
            Positioned(
              top: 380,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),



                  child: GestureDetector(
                    onTap: () async {
                      try {
                        if (_tryValidation()) {
                          final newUser =
                          await _authentication.signInWithEmailAndPassword(
                            email: _userEmail,
                            password: _userPassword,
                          );
                          if (newUser.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const MainPage();
                              }),
                            );
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.orange,
                            Colors.red,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),


                ),
              ),
            ), */
            //회원가입
            Positioned(
              top: MediaQuery.of(context).size.height - 150,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  const SizedBox(
                    height: 1,
                  ),

                  /// original 'sign up' button made by Minseok Seo
                  /*
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpPage();
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      minimumSize: const Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.red.shade700,
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  */

                  // Kakao login button
                  GestureDetector(
                      child: Container(
                          width:183,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image:AssetImage("assets/images/kakao_login_medium_narrow.png"),
                                fit:BoxFit.cover
                            ), // button text
                          )
                      ),onTap:() async {
                    if (await isKakaoTalkInstalled()) {
                      try {
                        await UserApi.instance.loginWithKakaoTalk();

                        print('카카오톡으로 로그인 성공');
                        _get_user_info();
                      } catch (error) {
                        print('카카오톡으로 로그인 실패 $error');

                        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                        try {
                          await UserApi.instance.loginWithKakaoAccount();
                          print('카카오계정으로 로그인 성공');
                          _get_user_info();
                        } catch (error) {
                          print('카카오계정으로 로그인 실패 $error');
                        }
                      }
                    } else {
                      try {
                        await UserApi.instance.loginWithKakaoAccount();
                        print('카카오계정으로 로그인 성공');
                        _get_user_info();
                      } catch (error) {
                        print('카카오계정으로 로그인 실패 $error');
                      }
                    }
                  }
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _get_user_info() async {
    try {
      MyApp.user = await UserApi.instance.me();
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }

    // 사용자의 추가 동의가 필요한 사용자 정보 동의 항목 확인
    List<String> scopes = [];
    //scopes.add("birthday");

    if (MyApp.user.kakaoAccount?.emailNeedsAgreement == true) {
      scopes.add('account_email');
    }
    if (MyApp.user.kakaoAccount?.birthdayNeedsAgreement == true) {
      scopes.add("birthday");
    }
    if (MyApp.user.kakaoAccount?.birthyearNeedsAgreement == true) {
      scopes.add("birthyear");
    }
    if (MyApp.user.kakaoAccount?.ciNeedsAgreement == true) {
      scopes.add("account_ci");
    }
    if (MyApp.user.kakaoAccount?.phoneNumberNeedsAgreement == true) {
      scopes.add("phone_number");
    }
    if (MyApp.user.kakaoAccount?.profileNeedsAgreement == true) {
      scopes.add("profile");
    }
    if (MyApp.user.kakaoAccount?.ageRangeNeedsAgreement == true) {
      scopes.add("age_range");
    }

    if (scopes.length > 0) {
      print('사용자에게 추가 동의 받아야 하는 항목이 있습니다');

      // OpenID Connect 사용 시
      // scope 목록에 "openid" 문자열을 추가하고 요청해야 함
      // 해당 문자열을 포함하지 않은 경우, ID 토큰이 재발급되지 않음
      // scopes.add("openid")

      // scope 목록을 전달하여 추가 항목 동의 받기 요청
      // 지정된 동의 항목에 대한 동의 화면을 거쳐 다시 카카오 로그인 수행
      OAuthToken token;
      try {
        token = await UserApi.instance.loginWithNewScopes(scopes);
        print('현재 사용자가 동의한 동의 항목: ${token.scopes}');
      } catch (error) {
        print('추가 동의 요청 실패 $error');
        return;
      }
    }

    // 사용자 정보 재요청
    try {
      MyApp.user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${MyApp.user.id}'
          '\nkakaoAccount: ${MyApp.user.kakaoAccount}'
          '\n닉네임: ${MyApp.user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${MyApp.user.kakaoAccount?.email}'
          '\n생일: ${MyApp.user.kakaoAccount?.birthday}'
      );
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
    print('모든 로그인 프로세스 종료');
  }



}
