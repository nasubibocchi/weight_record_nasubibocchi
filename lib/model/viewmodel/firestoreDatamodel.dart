import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';
import 'package:weight_record_nasubibocchi/objects/record.dart';

///provider
final firestoreDataModelProvider =
    StateNotifierProvider<DataModelState, DataModel>((ref) => DataModelState());

///properties
class DataModel {
  DataModel({required this.newHeight});
  String newHeight;
}

///model
class DataModelState extends StateNotifier<DataModel> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Map<DateTime, double> gotDateAndWeight = {};
  final _dayModel = DayModel();
  QueryDocumentSnapshot? lastVisible;
  bool hitTheBottom = false;

  DataModelState() : super(DataModel(newHeight: ''));

  ///firestoreのデータ(今月)をRecord型のオブジェクトにして監視
  Future<List<Record>> getDateAndWeight() async {
    final _email = auth.currentUser!.email;
    List<Record> recordList = [];


    final _collectionRef = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('date');

    QuerySnapshot _collection = await _collectionRef.get();

    //取得件数０だったらリターン（snapshots.docs[ここがマイナスになったら怒られる]）
    if (_collection.docs.isEmpty) {
      print('first get nothing');
      hitTheBottom = true;
      return recordList;
    }
    lastVisible = _collection.docs[_collection.docs.length - 1];
    // ignore: join_return_with_assignment
    recordList = _collection.docs.map((doc) => Record(doc)).toList();
    return recordList;

    // final recordList = _collection.docs.map((e) => Record(e)).toList();
    // print(recordList[0]);
    // state = DataModel(recordList: recordList);
  }

  Future<String> maxWeight () async {
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

  // ///リストの単純な型変換
  // List<double> typeChange ({required List list}) {
  //   List<double> changedList = [];
  //   changedList = list as List<double>;
  //   return changedList;
  // }

  ///最新の身長データをとってくる
  Future<void> getHeightData () async {
    final _email = auth.currentUser!.email;
    final _collectionRef = firestore
        .collection('user')
        .doc(_email)
        .collection(_dayModel.getYearAndMonthString(date: DateTime.now()))
        .orderBy('date');

    final _doc = await _collectionRef.get();
    final _data = _doc.docs.map((e) => e.data()['height']).toList();
    state = DataModel(newHeight: _data[0]);
  }

}
