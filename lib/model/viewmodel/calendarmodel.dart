import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weight_record_nasubibocchi/model/symplemodel/dayModel.dart';

final calendarModelProvider = StateNotifierProvider<CalendarModelState, CalendarModel>((ref) => CalendarModelState());

class CalendarModel {
  CalendarModel ({required this.yearAndMonth});
  String yearAndMonth;
}

class CalendarModelState extends StateNotifier<CalendarModel> {
  CalendarModelState() : super(CalendarModel(yearAndMonth:  DayModel().getYearAndMonthString(date: DateTime.now())));

  void notifyYearAndMonthState ({required input}) {
    state = CalendarModel(yearAndMonth: input);
  }
}