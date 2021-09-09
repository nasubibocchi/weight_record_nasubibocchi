import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/main.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/loginmodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/addmodel.dart';

class UserPage extends HookConsumerWidget {
  String username = '';
  String email = '';
  String password = '';
  final auth = FirebaseAuth.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

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
                  hintText: 'パスワードを入力',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _passwordController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  password = text;
                },
              ),
              SizedBox(width: 10.0, height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () => _loginModel.signInButtonPressed(
                        context: context,
                        email: email,
                        password: password,
                        username: username,
                        errorMessage: errorMessage,
                        successShowDialog: () => _addModelController.showMyDialog(
                            context: context, text: '登録しました。ログインボタンを押してください。'),
                        errorShowDialog: (errorMessage) async => await _addModelController.showMyDialog(
                            context: context, text: errorMessage)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    color: kNuanceColour,
                    elevation: 5.0,
                    child: Text(
                      '登録',
                      style: kBlackTextStyle,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => _loginModel.loginButtonPressed(
                        context: context,
                        routePage: myTab(),
                        email: email,
                        password: password,
                        username: username,
                        errorMessage: errorMessage,
                        errorShowDialog: (errorMessage) async => await _addModelController.showMyDialog(
                            context: context, text: errorMessage)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    color: kNuanceColour,
                    elevation: 5.0,
                    child: Text(
                      'ログイン',
                      style: kBlackTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0, height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
