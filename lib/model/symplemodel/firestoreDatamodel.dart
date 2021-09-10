import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';
import 'package:weight_record_nasubibocchi/objects/record.dart';



///model
class DataModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Map<DateTime, double> gotDateAndWeight = {};
  final _dayModel = DayModel();
  QueryDocumentSnapshot? lastVisible;
  bool hitTheBottom = false;


  ///firestoreのデータ(今月)をRecord型のオブジェクトにして取得
  Future<List<Record>> getDateAndWeight() async {
    final _email = auth.currentUser!.email;
    List<Record> recordList = [];
    List<Record> oldrecordList = [];

    final _collectionRef = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('date');

    ///先月分まで考慮する（月初めは今月のデータがないので表示するものがなくなる）
    final _oldcollectionref = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(
            date: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day)))
        .orderBy('date');

    QuerySnapshot _collection = await _collectionRef.get();
    QuerySnapshot _oldcollection = await _oldcollectionref.get();

    ///取得件数０だったらリターン（snapshots.docs[ここがマイナスになったら怒られる]）
    if (_collection.docs.isEmpty) {
      print('first get nothing');
      hitTheBottom = true;
      return recordList;
    }
    lastVisible = _collection.docs[_collection.docs.length - 1];
    // ignore: join_return_with_assignment
    recordList = _collection.docs.map((doc) => Record(doc)).toList();
    oldrecordList = _oldcollection.docs.map((doc) => Record(doc)).toList();
    oldrecordList.addAll(recordList);

    return oldrecordList;

    // final recordList = _collection.docs.map((e) => Record(e)).toList();
    // print(recordList[0]);
    // state = DataModel(recordList: recordList);
  }

  ///firestoreのデータ(今月)をRecord型のオブジェクトにして監視（未使用）
  Stream<List> getDateAndWeight2() {
    final _email = auth.currentUser!.email;
    final _recordList;
    final _oldrecordList;

    final _newSnapshot = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('date')
        .snapshots();

    ///先月分まで考慮する（月初めは今月のデータがないので表示するものがなくなる）
    final _oldSnapshot = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(
            date: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day)))
        .orderBy('date')
        .snapshots();

    // ignore: join_return_with_assignment
    _recordList = _newSnapshot.toList();
    _oldrecordList = _oldSnapshot.toList();
    _oldrecordList.addAll(_recordList);
    // _oldrecordList.sort((b, a) => a.date!.compareTo(b.date!));

    return _oldrecordList;
  }

  Future<String> maxWeight() async {
    String _weight;
    List<dynamic> _weightList = [];
    final _email = auth.currentUser!.email;
    final _collectionRef = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('weight');

    final _collection = await _collectionRef.get();
    _weightList = _collection.docs.map((e) => e.data()['weight']).toList();

    _weight = _weightList[0];
    return _weight;
  }

  ///最新の身長データをとってくる
  Future<dynamic> getHeightData() async {
    final _email = auth.currentUser!.email;
    final _newcollectionRef = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('date');

    ///先月分まで考慮する（月初は今月のデータがないので表示するものがなくなる）
    final _oldcollectionref = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(
            date: DateTime(DateTime.now().year, DateTime.now().month - 1,
                DateTime.now().day)))
        .orderBy('date');

    final _newdoc = await _newcollectionRef.get();
    final _olddoc = await _oldcollectionref.get();
    List _newdata = _newdoc.docs.map((e) => e.data()['height']).toList();
    List _olddata = _olddoc.docs.map((e) => e.data()['height']).toList();
    _newdata.addAll(_olddata);
    return _newdata[0];
    // state = DataModel(newHeight: _newdata[0]);
  }
}
