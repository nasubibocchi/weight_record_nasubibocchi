import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/firestoreDatamodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/addmodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/bmimodel.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/loginmodel.dart';

class RecordPage extends HookConsumerWidget {
  RecordPage({required this.date});

  String date;
  String weight = '';
  String height = '';
  String memo = '';
  double bmi = 0.0;
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _addController = ref.watch(userInfoModelProvider.notifier);
    final _bmiController = BmiModel();
    final _fireStoreDataController = ref.watch(firestoreDataModelProvider);

    ///TODO: 身長が変化した時にはデフォルトも修正する
    TextEditingController _heightController =
        TextEditingController(text: _fireStoreDataController.newHeight);
    TextEditingController _dateController = TextEditingController(text: date);
    TextEditingController _weightController = TextEditingController();
    TextEditingController _memoController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //TODO: テキストフィールド → ドロップダウンリストにする
              TextField(
                decoration: InputDecoration(
                  labelText: 'DAY',
                  hintText: '2021-09-03',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _dateController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  date = text;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'WEIGHT',
                  hintText: '50.0',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _weightController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  weight = text;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'HEIGHT',
                  hintText: '165.6',
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
                  labelText: 'MEMO',
                  hintText: '例 : 食べすぎた',
                  labelStyle: kBlackTextStyle,
                ),
                controller: _memoController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  memo = text;
                  //print(_memoController.text);
                },
              ),
              SizedBox(
                width: 10.0,
                height: 16.0,
              ),
              MaterialButton(
                onPressed: () {
                  bmi = _bmiController.BmiCalc(height: double.parse(height), weight: double.parse(weight))!;
                  _addController.addRecord(
                      email: auth.currentUser!.email,
                      date: date,
                      stringHeight: height,
                      stringWeight: weight,
                      memo: memo,
                      bmi: bmi.toStringAsFixed(1));
                  ///ポップアップウインドウを出す
                  _addController.showMyDialog(context: context, text: 'データを記録しました');
                },
                height: 50.0,
                child: Icon(
                  Icons.add,
                  color: kMainColour,
                ),
                color: kAccentColour,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                elevation: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
