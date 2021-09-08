import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';
import 'package:weight_record_nasubibocchi/model/viewmodel/firestoreDatamodel.dart';

import '../model/viewmodel/chartmodel.dart';
import 'datas.dart';

///BarChartSampleNasubi()を呼び出せば棒グラフを表示できるよ
class BarChartSampleNasubi extends HookConsumerWidget {
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
                                        _model.weekDay = snapshot.data
                                            .map((e) => e.date!.day.toString())
                                            .toList()[group.x.toInt()] + '日';

                                        return BarTooltipItem(
                                          _model.weekDay! + '\n',
                                          TextStyle(
                                            color: kMainColour,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: (rod.y).toString(),
                                              style: TextStyle(
                                                color: kMainColour,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    // touchCallback: _modelState.BarTouchResponse(barTouchResponse),
                                  ),

                                  ///軸データの表示と設定
                                  titlesData: FlTitlesData(
                                    show: true,

                                    ///x軸
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30.0,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              color: kBaseColour,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                      margin: 24,
                                      getTitles: (double value) {
                                        return snapshot.data
                                            .map((e) => e.date!.day.toString())
                                            .toList()[value.toInt()];
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
                                      snapshot.data.length < 7
                                          ? snapshot.data.length
                                          : 7, (index) {
                                        ///グラフの上限値を出力する準備
                                        List _test = snapshot.data
                                            .map((e) => double.parse(e.weight!))
                                            .toList();
                                        _test.sort((b, a) => a.compareTo(b));
                                        // print(_test[0]);
                                    return _modelState.makeGroupData(
                                        ///データインデックス
                                        index,
                                        ///firestoreの体重データ
                                        snapshot.data
                                            .map((e) => double.parse(e.weight!))
                                            .toList()[index],
                                        ///firestoreの体重データの最大値+10kgをグラフ上限に設定
                                        _test[0] + 10.0,
                                        // 100.0,//ダミー
                                        ///どのデータがタッチされたか
                                        isTouched:
                                            index == _model.touchedIndex);
                                  }),
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
