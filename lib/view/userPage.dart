import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/loginmodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/addmodel.dart';

class UserPage extends HookConsumerWidget {
  String username = '';
  String height = '';
  String email = '';
  String password = '';
  final auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String exportedHeight = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _loginModel = LoginModel();
    final _addModelController = ref.read(userInfoModelProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //TODO: 体裁を整える
              TextField(
                decoration: InputDecoration(
                  labelText: 'name',
                  hintText: '例 : ヒトミ',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _nameController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  username = text;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'height',
                  hintText: '168.5',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _heightController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  height = text;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'mail',
                  hintText: 'xxxx@gmail.com',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _emailController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  email = text;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'password',
                  hintText: '6文字以上',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _passwordController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  password = text;
                },
              ),
              SizedBox(width: 10.0, height: 20.0),
              MaterialButton(
                onPressed: () async {
                  try {
                    await auth
                        .createUserWithEmailAndPassword(
                            email: email, password: password)
                        .then((value) {
                      print(FirebaseAuth.instance.currentUser!.displayName);
                    });
                    await auth
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        .then((value) {
                      print(FirebaseAuth.instance.currentUser!.displayName);
                    });

                    ///ユーザーネームと身長をfirestoreに登録
                    _loginModel.addUsersName(
                        nickname: username, email: email, stringHeight: height);

                    ///heightをデフォルトとして記憶しておく
                    exportedHeight = _loginModel.exportedHeight;

                    ///NavigationPagesへ移動
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tab()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (auth.currentUser!.email != null) {
                      _addModelController.showMyDialog(
                          context: context, text: 'アカウントがすでにあるようです。');
                    }
                    print('ログイン失敗');
                    print(e);
                  } on Exception catch (e) {
                    print('ログイン成功');
                    print(e);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                color: kNuanceColour,
                elevation: 5.0,
                child: Text(
                  'はじめる',
                  style: kBlackTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
