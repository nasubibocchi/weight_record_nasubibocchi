import 'dart:math';

///properties
class BmiModel {
  double? bmi;
  double? weight;

  ///bmiの計算
  double? BmiCalc ({required height, required weight}) {
    bmi = weight / pow(height * 0.01, 2);
    return bmi;
  }
}
