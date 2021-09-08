import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData (DocumentSnapshot doc) {
    Map<String, dynamic> extractdata = doc.data() as Map<String, dynamic>;
    this.documentReference = doc.reference;
    //this.userId = extractdata['userId'];
    this.nickname = extractdata['nickname'];
    this.email = extractdata['email'];
    this.height = extractdata['height'];
  }

  String? nickname;
  //String? userId;
  String? email;
  String? height;
  DocumentReference? documentReference;
}