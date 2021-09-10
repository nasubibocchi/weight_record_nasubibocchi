import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/firestoreDatamodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/addmodel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/bmimodel.dart';

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
    final _fireStoreModel = DataModel();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FutureBuilder(
          future: _fireStoreModel.getHeightData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              TextEditingController _heightController = TextEditingController();
              TextEditingController _dateController =
                  TextEditingController(text: date);
              TextEditingController _weightController = TextEditingController();
              TextEditingController _memoController = TextEditingController();

              return recordForm(
                  dateController: _dateController,
                  weightController: _weightController,
                  heightController: _heightController,
                  memoController: _memoController,
                  date: date,
                  weight: weight,
                  height: height,
                  memo: memo,
                  bmi: bmi,
                  bmiFunction: () => _bmiController.BmiCalc(
                      height: double.parse(height),
                      weight: double.parse(weight))!,
                  addFunction: () => _addController.addRecord(
                      email: auth.currentUser!.email,
                      date: date,
                      stringHeight: height,
                      stringWeight: weight,
                      memo: memo,
                      bmi: bmi.toStringAsFixed(1)),
                  showMyDialog: () => _addController.showMyDialog(
                      context: context, text: 'データを記録しました'));
            } else {
              TextEditingController _heightController =
                  TextEditingController(text: snapshot.data);
              TextEditingController _dateController =
                  TextEditingController(text: date);
              TextEditingController _weightController = TextEditingController();
              TextEditingController _memoController = TextEditingController();
              return recordForm(
                  dateController: _dateController,
                  weightController: _weightController,
                  heightController: _heightController,
                  memoController: _memoController,
                  date: date,
                  weight: weight,
                  height: height,
                  memo: memo,
                  bmi: bmi,
                  bmiFunction: () => _bmiController.BmiCalc(
                      height: double.parse(height),
                      weight: double.parse(weight))!,
                  addFunction: () => _addController.addRecord(
                      email: auth.currentUser!.email,
                      date: date,
                      stringHeight: height,
                      stringWeight: weight,
                      memo: memo,
                      bmi: bmi.toStringAsFixed(1)),
                  showMyDialog: () => _addController.showMyDialog(
                      context: context, text: 'データを記録しました'));
            }
          },
        ),
      ),
    );
  }
}

Widget recordForm(
    {required TextEditingController dateController,
    required TextEditingController weightController,
    required TextEditingController heightController,
    required TextEditingController memoController,
    required String date,
    required String weight,
    required String height,
    required String memo,
    required double bmi,
    required Function bmiFunction,
    required Function addFunction,
    required showMyDialog}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'DAY',
            hintText: '2021-09-03',
            labelStyle: kBlackTextStyle,
          ),
          controller: dateController,
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
          controller: weightController,
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
          controller: heightController,
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
          controller: memoController,
          keyboardType: TextInputType.text,
          onChanged: (text) {
            memo = text;
          },
        ),
        SizedBox(
          width: 10.0,
          height: 16.0,
        ),
        MaterialButton(
          onPressed: () {
            bmi = bmiFunction();
            addFunction();

            ///ポップアップウインドウを出す
            showMyDialog();
          },
          height: 50.0,
          child: Icon(
            Icons.add,
            color: kMainColour,
          ),
          color: kAccentColour,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 5.0,
        ),
      ],
    ),
  );
}
