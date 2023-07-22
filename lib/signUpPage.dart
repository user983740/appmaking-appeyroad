import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Sign Up 버튼 클릭 시 표시할 페이지
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpWidget();
}

class _SignUpWidget extends State<SignUpPage> {
  final _authentication = FirebaseAuth.instance;
  final _userData = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _userId = '';
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  String _userNumber = '';
  bool _isIdRepetitionChecked = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;


  //ID 중복 검사
  Future<bool> _isIdRepeated(String id) async{
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.
    collection('users').where('userId', isEqualTo: id).get();

    return querySnapshot.docs.isNotEmpty;
  }

  //비밀번호 textform의 글자 숨김 여부
  void _toggleObscure1() {
    setState(() {
      _isObscure1 = !_isObscure1;
    });
  }

  //비밀번호 확인 textform의 글자 숨김 여부
  void _toggleObscure2() {
    setState(() {
      _isObscure2 = !_isObscure2;
    });
  }

  //form들이 유효한지 검사
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
            //상단의 회원가입 글자
            Positioned(
              top: 10,
              width: MediaQuery.of(context).size.width,
              child: const Text('회원 가입',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //정보 입력창들
            Positioned(
              top:50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                key: const ValueKey(11),
                                validator: (value){
                                  RegExp idRegex = RegExp(r'^[A-Za-z\d]+$');
                                  if(value!.isEmpty){
                                    return 'ID를 입력하세요';
                                  }
                                  else if(!idRegex.hasMatch(value)){
                                    return('ID는 영어 또는 숫자로만 이루어져야 합니다.');
                                  }
                                  else if(!_isIdRepetitionChecked) {
                                    return('ID 중복확인을 진행해주세요.');
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  _userId = value!;
                                },
                                onChanged: (value){
                                  _userId = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: '사용자 ID',
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width:12,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextButton(
                                onPressed: () async {
                                  bool _isIdDuplicated = await _isIdRepeated(_userId);

                                  if(_isIdDuplicated){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: const Text('이미 사용 중인 아이디입니다.'),
                                          actions:[
                                            TextButton(
                                              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                              child: const Text('확인'),
                                              onPressed: (){Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          content: const Text('사용가능한 아이디입니다.'),
                                          actions:[
                                            TextButton(
                                              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                              child: const Text('확인'),
                                              onPressed: (){Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    _isIdRepetitionChecked = true;
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('중복확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height:12,
                        ),
                        TextFormField(
                          key: const ValueKey(12),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'email을 입력하세요';
                            }
                            else if(!value.contains('@') || !value.contains('com')){
                              return('email 형식이 올바르지 않습니다.');
                            }
                            return null;
                          },
                          onSaved: (value){
                            _userEmail = value!;
                          },
                          onChanged: (value){
                            _userEmail = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'email',
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(
                          height:12,
                        ),
                        TextFormField(
                          obscureText: _isObscure1,
                          key: const ValueKey(13),
                          validator: (value){
                            RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?!.*[ㄱ-ㅎㅏ-ㅣ가-힣]).+$');
                            if(value!.isEmpty){
                              return '비밀번호를 입력하세요';
                            }
                            else if(value.length < 8){
                              return '비밀번호는 8글자 이상이어야 합니다.';
                            }
                            else if(!passwordRegex.hasMatch(value)){
                              return('비밀번호는 영어와 숫자를 모두 포함해야 하고 한글이 포함되면 안됩니다.');
                            }
                            return null;
                          },
                          onSaved: (value){
                            _userPassword = value!;
                          },
                          onChanged: (value){
                            _userPassword = value;
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: _toggleObscure1,
                              child: Icon(_isObscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: '비밀번호',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(
                          height:12,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          key: const ValueKey(14),
                          validator: (value){
                            if(value != _userPassword){
                              return '비밀번호가 일치하지 않습니다.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: _toggleObscure2,
                              child: Icon(_isObscure2
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: '비밀번호 확인',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(
                          height:12,
                        ),
                        TextFormField(
                          key: const ValueKey(15),
                          validator: (value){
                            RegExp nameRegex = RegExp(r'^[가-힣]{2,}$');
                            if(value!.isNotEmpty && !nameRegex.hasMatch(value)){
                              return '한글로 된 이름을 입력하세요.';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _userName = value!;
                          },
                          onChanged: (value){
                            _userName = value;
                          },
                          decoration: const InputDecoration(
                            labelText: '이름(선택)',
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(
                          height:12,
                        ),
                        TextFormField(
                          key: const ValueKey(16),
                          validator: (value){
                            RegExp phoneNumberRegex = RegExp(r'^010-\d{4}-\d{4}$');
                            if(value!.isNotEmpty && !phoneNumberRegex.hasMatch(value)){
                              return '전화번호 형식이 올바르지 않습니다.';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _userNumber = value!;
                          },
                          onChanged: (value){
                            _userNumber = value;
                          },
                          decoration: const InputDecoration(
                            labelText: '전화번호(선택)',
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //확인 버튼
            Positioned(
              top: 600,
              right: 0,
              left: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async{
                    try {
                      if (_tryValidation()) {
                        final newUser = await _authentication
                            .createUserWithEmailAndPassword(
                          email: _userEmail,
                          password: _userPassword,
                        );

                        _userData.collection("users").add({
                          'userId' : _userId,
                          'email': _userEmail,
                          'password': _userPassword,
                          'userName': _userName,
                          'userPhoneNumber': _userNumber,
                        });

                        if (newUser.user != null) {
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.red,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(child: Text('확인', style: TextStyle(color:Colors.white))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

