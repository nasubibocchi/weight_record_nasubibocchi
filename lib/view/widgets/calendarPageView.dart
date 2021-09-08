import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/calendarmodel.dart';
import 'package:weight_record_nasubibocchi/objects/record.dart';
import 'package:weight_record_nasubibocchi/view/recordPage.dart';

class CalendarPageView extends HookConsumerWidget {
  ///初期化
  String _yearAndMonth = DayModel().getYearAndMonthString(date: DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _calendarModelController = ref.watch(calendarModelProvider.notifier);
    final _calendarModelState = ref.watch(calendarModelProvider);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Center(
              child: new DropdownButton<String>(
                elevation: 5,
                menuMaxHeight: 200.0,
                items: dropDownList.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  _yearAndMonth = value!;
                  _calendarModelController.notifyYearAndMonthState(
                      input: _yearAndMonth);
                },
              ),
            ),
          ),

          /// スクロールできるコンポーネント
          Expanded(
            child: CalendarPage(
                stateYearAndMonth: _calendarModelState.yearAndMonth),
          ),
        ],
      ),
    );
  }
}

class CalendarPage extends HookConsumerWidget {
  CalendarPage({required this.stateYearAndMonth});

  String stateYearAndMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final _email = auth.currentUser!.email;

    return StreamBuilder(
      stream: firestore
          .collection('user')
          .doc(_email)
          .collection(stateYearAndMonth)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        /// エラー発生時はエラーメッセージを表示
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: SizedBox(
              height: 500.0,
              width: 280.0,
              child: Card(
                color: kAccentColour,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 5.0,
                child: Container(
                  height: 50.0,
                  width: 28.0,
                  child: Center(
                    child: Text(
                      'NO DATA',
                      style: kWhiteTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          final _newSnapshot =
              snapshot.data!.docs.map((e) => Record(e)).toList();
          return PageView.builder(
            controller: PageController(initialPage: 1200),
            itemCount: _newSnapshot.length,
            itemBuilder: (BuildContext context, int index) {
              return recordDataCard(
                  context: context, recordDataList: _newSnapshot, index: index);
            },
          );
        }
      },
    );
  }
}

Widget recordDataCard(
    {required BuildContext context,
    required List<Record> recordDataList,
    required int index}) {
  final _dayModel = DayModel();

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 500.0,
          width: 280.0,
          child: Card(
            color: kAccentColour,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5.0,
            child: Center(
              child: Container(
                height: 600.0,
                width: 400.0,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: IconButton(
                          alignment: Alignment.bottomRight,
                          onPressed: () {
                            ///表示ページの日付と一致する記録ページに遷移
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecordPage(
                                        date: _dayModel.formattedDate(
                                            date:
                                                recordDataList[index].date!))));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: kMainColour,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '-' +
                                recordDataList[index].date!.day.toString() +
                                '日-',
                            style: TextStyle(
                                fontSize: 30.0,
                                color: kMainColour,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text('WEIGHT', style: kWhiteTextStyle),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(recordDataList[index].weight!,
                                        style: kNumberTextStyle),
                                    Text('kg', style: kWhiteTextStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text('BMI', style: kWhiteTextStyle),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(recordDataList[index].bmi!,
                                        style: kNumberTextStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text('MEMO', style: kWhiteTextStyle),
                                Text(recordDataList[index].memo!,
                                    style: kWhiteTextStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DotsIndicator(
          dotsCount: recordDataList.length,
          position: index.toDouble(),
          decorator:
              DotsDecorator(color: kNuanceColour, activeColor: kAccentColour),
        )
      ],
    ),
  );
}

///dropDownに表示するリスト
List<String> dropDownList = [
  '2021-8',
  '2021-9',
  '2021-10',
  '2021-11',
  '2021-12',
  '2022-1',
  '2022-2',
  '2022-3',
  '2022-4',
  '2022-5',
  '2022-6',
  '2022-7',
  '2022-8',
  '2022-9',
  '2022-10',
  '2022-11',
  '2022-12',
  '2023-1',
  '2023-2',
  '2023-3',
  '2023-4',
  '2023-5',
  '2023-6',
  '2023-7',
  '2023-8',
  '2023-9',
  '2023-10',
  '2023-11',
  '2023-12',
  '2024-1',
  '2024-2',
  '2024-3',
  '2024-4',
  '2024-5',
  '2024-6',
  '2024-7',
  '2024-8',
  '2024-9',
  '2024-10',
  '2024-11',
  '2024-12',
  '2025-1',
  '2025-2',
  '2025-3',
  '2025-4',
  '2025-5',
  '2025-6',
  '2025-7',
  '2025-8',
  '2025-9',
  '2025-10',
  '2025-11',
  '2025-12',
  '2026-1',
  '2026-2',
  '2026-3',
  '2026-4',
  '2026-5',
  '2026-6',
  '2026-7',
  '2026-8',
  '2026-9',
  '2026-10',
  '2026-11',
  '2026-12',
  '2027-1',
  '2027-2',
  '2027-3',
  '2027-4',
  '2027-5',
  '2027-6',
  '2027-7',
  '2027-8',
  '2027-9',
  '2027-10',
  '2027-11',
  '2027-12',
];
