import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_record_nasubibocchi/objects/userdata.dart';

class LoginModel {
  String? nickname;
  String? email;
  String? stringHeight;
  bool? isLoginLoading;
  bool? isUserLogin;
  String? uid;
  String exportedHeight = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserData? userData;

  ///signOut
  Future signOut() async {
    await auth.signOut();
    userData = null;
  }

  ///firestoreにユーザー情報を登録
  Future<void> addUsersName({required nickname, required email}) async {
    final _doc = firestore.collection('user').doc(email);
    await _doc.set({
      'nickname': nickname,
      //'userId': state.uid,
      'email': email,
      //'height': stringHeight,
    });
  }

  // ///一度入力した身長を扱えるようにしておく（身長が頻繁に変化しないものとしてデフォルトでRecordPageに入力しておく）
  // String recordHeight ({required height}) {
  //   exportedHeight = height;
  //   return exportedHeight;
  // }

  ///login中
  void startLoginLoading() {
    isLoginLoading = true;
  }

  ///login中でない
  void endLoginLoading() {
    isLoginLoading = false;
  }

  Future<void> getUserData() async {
    // final uid = auth.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('user').doc(email).get();
    userData = UserData(snapshot);
    print('--------------------------user info get');
  }

  Future<UserData?> getUserDataReturn() async {
    //final uid = auth.currentUser!.uid;
    final snapshot = await firestore.collection('user').doc(email).get();
    userData = UserData(snapshot);
    print('----------------------------user info get');
    return userData;
  }

  Future <void> signInButtonPressed(
      {required BuildContext context,
      required String email,
      required String password,
      required String username,
      required String errorMessage, required successShowDialog,
      required errorShowDialog}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(FirebaseAuth.instance.currentUser!.displayName);
      });
      successShowDialog;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "メールアドレスの形式が正しくないようです。";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "パスワードが間違っているようです。";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "このメールアドレスは存在しないようです。";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "このメールアドレスのユーザーは無効になりました。";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "メールアドレスとパスワードを使用したサインインが有効になっていません。";
          break;
        default:
          errorMessage = "原因不明のエラーが発生したようです。";
      }
      if (errorMessage != null) {
        //_addModelController.showMyDialog(context: context, text: errorMessage);
        errorShowDialog;
        return Future.error(errorMessage);
      }
      print('ログイン失敗');
      print(e);
    } on Exception catch (e) {
      print('ログイン成功');
      print(e);
    }
  }

  Future<void> loginButtonPressed(
      {required BuildContext context,
      required Widget routePage,
      required String email,
      required String password,
      required String username,
      required String errorMessage,
      required errorShowDialog}) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(FirebaseAuth.instance.currentUser!.displayName);
      });

      ///ユーザーネームとメールアドレスをfirestoreに登録
      final _doc = firestore.collection('user').doc(email);
      await _doc.set({
        'nickname': username,
        'email': email,
      });

      ///NavigationPagesへ移動
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routePage),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "メールアドレスの形式が正しくないようです。";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "パスワードが間違っているようです。";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "このメールアドレスは存在しないようです。";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "このメールアドレスのユーザーは無効になりました。";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "メールアドレスとパスワードを使用したサインインが有効になっていません。";
          break;
        default:
          errorMessage = "原因不明のエラーが発生したようです。";
      }
      if (errorMessage != null) {
        //_addModelController.showMyDialog(context: context, text: errorMessage);
        errorShowDialog;
        return Future.error(errorMessage);
      }
      print('ログイン失敗');
      print(e);
    } on Exception catch (e) {
      print('ログイン成功');
      print(e);
    }
  }
}
