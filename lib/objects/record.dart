import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  Record (DocumentSnapshot doc) {
    Map<String, dynamic> extractdata = doc.data() as Map<String, dynamic>;
    this.documentReference = doc.reference;
    this.nickname = extractdata['nickname'];
    this.bmi = extractdata['bmi'];
    this.weight = extractdata['weight'];
    this.height = extractdata['height'];
    this.memo = extractdata['memo'];
    final Timestamp timestamp = extractdata['date'];
    this.date = timestamp.toDate();
  }

  String? nickname;
  String? height;
  String? weight;
  String? memo;
  String? bmi;
  DateTime? date;
  DocumentReference? documentReference;
}