import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/api/preload_api.dart';
import 'package:date_util/date_util.dart';
import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreenBloc extends Bloc<CalendarScreenEvent, CalendarScreenState> {
  HistoryApi historyApi = new HistoryApi();
  StudentApi studentApi = new StudentApi();
  PreLoadApi preLoadApi = new PreLoadApi();
  final dateUtility = DateUtil();

  CalendarScreenBloc(CalendarScreenState initialState) : super(initialState);

  CalendarScreenState get initialState {
    return CalendarScreenState(isLoading: true);
  }

  @override
  Stream<CalendarScreenState> mapEventToState(CalendarScreenEvent event,) async* {
    if (event is CalendarScreenInitEvent) {
      yield* getMonthHistory(DateTime.now());
    } else if (event is GetMonthHistoryEvent) {
      yield* getMonthHistory(event.month);
    } else if (event is GetWeekHistoryEvent) {
      yield* getWeekHistory(event.startDate, event.endDate);
    } else if (event is GetDayHistoryEvent) {
      yield* getDayHistory(event.date);
    } else if (event is RefreshProgressEvent) {
    } else if (event is CalendarLoadingEvent) {
      yield state.copyWith(isLoading: event.isLoading);
    }
  }

  Stream<CalendarScreenState> loadInitialData() async* {
  }
  //////////////////////////////////////////////////////////////////////////////
  //                      Get history
  //////////////////////////////////////////////////////////////////////////////

  Stream<CalendarScreenState> getMonthHistory(DateTime month) async* {
    try {
      yield state.copyWith(isLoading: true);
      int day = dateUtility.daysInMonth(month.month, month.year);
      String startDate = '${month.month}/1/${month.year}';
      String endDate = '${month.month}/$day/${month.year}';
      List<HistoryModel> history = await historyApi.getHistoryList(
          sdate: startDate, endDate: endDate);
      if (history.length > 0) history.sort((a,b) => a.starttime.compareTo(b.starttime));

      final List<DateTime> blockedDates = <DateTime>[];
      DateTime firstDate = DateTime(month.year, month.month, 1);
      for (int i = 0; i < dateUtility.daysInMonth(firstDate.month, firstDate.year); i++) {
        firstDate = firstDate.add(Duration(days: 1));
        if (!isAvailable(firstDate)) {
          blockedDates.add(firstDate);
        }
      }

      yield state.copyWith(history: history, blackoutDates: blockedDates, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield CalendarScreenStateFailure(error: error.toString());
    }
  }

  Stream<CalendarScreenState> getWeekHistory(String startDate, String endDate) async* {
    try {
      List<HistoryModel> history = await historyApi.getHistoryList(
          sdate: startDate, endDate: endDate);
      if (history.length > 0) history.sort((a,b) => a.starttime.compareTo(b.starttime));
      yield state.copyWith(history: history, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield CalendarScreenStateFailure(error: error.toString());
    }
  }

  Stream<CalendarScreenState> getDayHistory(String date) async* {
    try {
      List<HistoryModel> history = [];
      List<HistoryModel> filter = [];
      history.addAll(state.history);
      if (history.length > 0) {
        history.sort((a,b) => a.starttime.compareTo(b.starttime));

        if (GlobalCall.filterStudents && GlobalCall.student != '') {
          filter = history.where((element) => element.sname == GlobalCall.student).toList();
        } else {
          filter = history;
        }
        if (GlobalCall.filterSessionTypes && GlobalCall.sessionType != '') {
          filter = filter.where((element) => element.sessionType == GlobalCall.sessionType).toList();
        }
      }
      yield state.copyWith(history: filter, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield CalendarScreenStateFailure(error: error.toString());
    }
  }

}