import 'package:intl/intl.dart';

class DayModel {
  ///これ以降はただのメソッド（stateは変わらない）
  ///日付の文字列フォーマットを変更
  String formattedDate({required DateTime date}) {
    final _result = DateFormat('yyyy-MM-dd').format(date);
    return _result;
  }

  ///年月の文字列取得
  String getYearAndMonthString({required DateTime date}) {
    final _month = date.month;
    final _year = date.year;
    String _result = _year.toString() + '-' + _month.toString();
    return _result;
  }

// ///firestoreから自分の記録の年月リストを取得する
// Future<List<String>> getYearAndMonth () async {
//   final _email = auth.currentUser!.email;
//   List<String> _strYMList = [];
//   final _doc = firestore.collection('user').doc(_email).collection(collectionPath);
//   final _collection = _doc.parent;
//   final _collectionId = _collection.snapshots().map((event) => event.)
//
//   // final _docName = await _collection.get();
//   // _strYMList = _docName.docs.map((e) => e.id).toList();
//   return _strYMList;
// }

}