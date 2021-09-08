import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void> addUsersName(
      {required nickname, required stringHeight, required email}) async {
    final _doc = firestore.collection('user').doc(email);
    await _doc.set({
      'nickname': nickname,
      //'userId': state.uid,
      'email': email,
      'height': stringHeight,
    });
  }

  ///一度入力した身長を扱えるようにしておく（身長が頻繁に変化しないものとしてデフォルトでRecordPageに入力しておく）
  String recordHeight ({required height}) {
    exportedHeight = height;
    return exportedHeight;
  }

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
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(email)
        .get();
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
}