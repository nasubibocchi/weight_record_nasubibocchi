
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/constants/const.dart';

///provider
final chartModelProvider = StateNotifierProvider<ChartModelState, ChartModel>(
    (ref) => ChartModelState());

///properties(mutable)
class ChartModel {
  ///グラフバーの背景色
  final Color barBackgroundColor = kNuanceColour;
  final Duration animDuration = const Duration(milliseconds: 250);
  ChartModel({required int this.touchedIndex});

  ///デフォルトで"タップした時の表示"にしておきたいデータインデックスを代入
  int? touchedIndex;

  bool isPlaying = false;
  String? weekDay;
}

///state
class ChartModelState extends StateNotifier<ChartModel> {
  ChartModelState() : super(ChartModel(touchedIndex: -1));

  ///
  BarChartGroupData makeGroupData(
    int x,
    double y, double maxWeight, {
    bool isTouched = false,
    Color barColor = kAccentColour,
    double width = 20.0,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          ///棒グラフの棒をタップしたら起こることの設定
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: kAccentColour, width: 1)
              : BorderSide(color: kBaseColour, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxWeight,
            colors: [state.barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  ///グラフをタップした時の反応
  void BarTouchResponse (barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! PointerUpEvent &&
        barTouchResponse.touchInput is! PointerExitEvent) {
      // state.touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
      state = ChartModel(touchedIndex: barTouchResponse.spot!.touchedBarGroupIndex);
    } else {
      // state.touchedIndex = -1;
      state = ChartModel(touchedIndex: -1);
    }
  }

  ///
  Future<dynamic> refreshState() async {
    //setState(() {});
    await Future<dynamic>.delayed(
        state.animDuration + const Duration(milliseconds: 50));
    if (state.isPlaying) {
      await refreshState();
    }
  }
}
