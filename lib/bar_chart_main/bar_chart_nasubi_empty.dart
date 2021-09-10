import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/firestoreDatamodel.dart';

import '../model/viewmodel/chartmodel.dart';
import 'datas.dart';

///BarChartSampleNasubi()を呼び出せば棒グラフを表示できるよ
class BarChartSampleNasubiEmpty extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _model = ref.watch(chartModelProvider);
    final _modelState = ref.watch(chartModelProvider.notifier);
    ref.listen(
      chartModelProvider,
      (touchedIndex) {
        print('touchedIndex changes');
      },
    );
    // final _firestoreDataModel = ref.watch(firestoreDataModelProvider);
    // final recordData = _firestoreDataModel.recordList;
    final _firestoreDataModel = DataModelState();
    final _dayModel = DayModel();



    return FutureBuilder(
        future: _firestoreDataModel.getDateAndWeight(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),

                ///グラフ背景
                color: kMainColour,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),

                      ///グラフエリア
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            DateTime.now().month.toString() + '月',
                            style: TextStyle(
                                color: kBaseColour,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 38,
                          ),

                          ///グラフ本体
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),

                              ///【BarChart(data, swapAnimationDuration, swapAnimationCurve)】を使えば棒グラフが呼び出せる
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(
                                    show: false,
                                  ),

                                  ///タップした時に出てくる表示
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: kBaseColour,
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
                                        switch (group.x.toInt()) {
                                          case 0:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 6)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 1:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 5)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 2:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 4)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 3:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 3)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 4:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 2)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 5:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 1)
                                                    .toString() +
                                                '日';
                                            break;
                                          case 6:
                                            _model.weekDay = _dayModel
                                                    .lastDays(x: 0)
                                                    .toString() +
                                                '日';
                                            break;
                                          default:
                                            throw Error();
                                        }

                                        return BarTooltipItem(
                                          _model.weekDay! + '\n',
                                          TextStyle(
                                            color: kBaseColour,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: (rod.y - 1).toString(),
                                              style: TextStyle(
                                                color: kBaseColour,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    // touchCallback: _modelState.BarTouchResponse,
                                  ),

                                  ///軸データの表示と設定
                                  titlesData: FlTitlesData(
                                    show: true,

                                    ///x軸
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              color: kBaseColour,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                      margin: 16,
                                      getTitles: (double value) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 6))
                                                .toString();
                                          case 1:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 5))
                                                .toString();
                                          case 2:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 4))
                                                .toString();
                                          case 3:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 3))
                                                .toString();
                                          case 4:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 2))
                                                .toString();
                                          case 5:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 1))
                                                .toString();
                                          case 6:
                                            return _dayModel
                                                .dateTime2MonthDate(
                                                    date: _dayModel.lastDays(
                                                        x: 0))
                                                .toString();
                                          default:
                                            return '';
                                        }
                                      },
                                    ),

                                    ///y軸
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30.0,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              color: kBaseColour,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                      margin: 24,
                                      interval: 5.0,
                                      getTitles: (value) {
                                        if (value == 0) {
                                          return '0';
                                        } else if (value == 10) {
                                          return '10';
                                        } else if (value == 20) {
                                          return '20';
                                        } else if (value == 30) {
                                          return '30';
                                        } else if (value == 40) {
                                          return '40';
                                        } else if (value == 50) {
                                          return '50';
                                        } else if (value == 60) {
                                          return '60';
                                        } else if (value == 70) {
                                          return '70';
                                        } else if (value == 80) {
                                          return '80';
                                        } else if (value == 90) {
                                          return '90';
                                        } else if (value == 100) {
                                          return '100';
                                        } else if (value == 110) {
                                          return '120';
                                        } else {
                                          return '';
                                        }
                                      },
                                    ),

                                    ///第２軸は表示しない
                                    topTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                    rightTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),

                                  borderData: FlBorderData(
                                    show: false,
                                  ),

                                  ///y軸データ
                                  barGroups: List.generate(
                                    7,
                                    (i) {
                                      ///グラフの上限値を出力する準備
                                      List _test = snapshot.data
                                          .map((e) => double.parse(e.weight!))
                                          .toList();
                                      _test.sort((b, a) => a.compareTo(b));
                                      // print(_test[0]);
                                      ///snapshotデータの中にある日付のデータがあればその日の体重、なければ0を出力する
                                      switch (i) {
                                        case 0:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 6));
                                          final _data = _check != -1
                                              ? snapshot.data
                                                  .map((e) =>
                                                      double.parse(e.weight!))
                                                  .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                                  i == _model.touchedIndex);
                                        case 1:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 5));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        case 2:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 4));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        case 3:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 3));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        case 4:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 2));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        case 5:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 1));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        case 6:
                                          final _check = snapshot.data
                                              .map((e) => e.date!)
                                              .toList()
                                              .indexOf(_dayModel.lastDays(x: 0));
                                          final _data = _check != -1
                                              ? snapshot.data
                                              .map((e) =>
                                              double.parse(e.weight!))
                                              .toList()[_check]
                                              : 0.0;
                                          return _modelState.makeGroupData(
                                              i, _data, _test[0] + 10.0,
                                              isTouched:
                                              i == _model.touchedIndex);
                                        default:
                                          return throw Error();
                                      }
                                    },
                                  ),
                                  //TODO: データ本体。引数に表示させたいデータを指定。サンプルとして"sampleData"@datas.dartを表示している。
                                  // barGroups: List.generate(
                                  //   7,
                                  //       (i) {
                                  //     switch (i) {
                                  //       case 0:
                                  //         return _modelState.makeGroupData(
                                  //             0, sampleData.values.elementAt(0),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 1:
                                  //         return _modelState.makeGroupData(
                                  //             1, sampleData.values.elementAt(1),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 2:
                                  //         return _modelState.makeGroupData(
                                  //             2, sampleData.values.elementAt(2),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 3:
                                  //         return _modelState.makeGroupData(
                                  //             3, sampleData.values.elementAt(3),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 4:
                                  //         return _modelState.makeGroupData(
                                  //             4, sampleData.values.elementAt(4),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 5:
                                  //         return _modelState.makeGroupData(
                                  //             5, sampleData.values.elementAt(5),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       case 6:
                                  //         return _modelState.makeGroupData(
                                  //             6, sampleData.values.elementAt(6),
                                  //             isTouched: i == _model.touchedIndex);
                                  //       default:
                                  //         return throw Error();
                                  //     }
                                  //   },
                                  // ),
                                  // _modelState.showingGroupsNasubi(
                                  //     data: sampleData),
                                ),
                                swapAnimationDuration: _model.animDuration,
                                //swapAnimationCurve: Curves.easeOutCubic,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
        });
  }
}
