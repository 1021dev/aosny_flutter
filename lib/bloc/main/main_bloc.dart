import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/api/preload_api.dart';
import 'package:aosny_services/api/progress_amount_api.dart';
import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json, base64, ascii;

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  HistoryApi historyApi = new HistoryApi();
  ProgressAmountApi progressApi = new ProgressAmountApi();
  StudentApi studentApi = new StudentApi();
  PreLoadApi preLoadApi = new PreLoadApi();

  MainScreenBloc(MainScreenState initialState) : super(initialState);

  MainScreenState get initialState {
    return MainScreenState(isLoading: true);
  }

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event,) async* {
    if (event is MainScreenInitialEvent) {
      yield* loadInitialData();
    } else if (event is GetHistoryEvent) {
      yield* getHistory(event.startDate, event.endDate);
    } else if (event is RefreshHistoryEvent) {
      yield* refreshHistory(event.startDate, event.endDate);
    } else if (event is GetProgressEvent) {
      yield* getProgress(event.startDate, event.endDate);
    } else if (event is RefreshProgressEvent) {
      yield* getProgress(event.startDate, event.endDate);
    }
  }

  Stream<MainScreenState> loadInitialData() async* {
    try {
      yield state.copyWith(isLoading: true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      var jwt = token.split(".");
      var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
      GlobalCall.email =  payload['Email'];

      if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
        List<StudentsDetailsModel> studentList = new List();

        studentList = await studentApi.getAllStudentsList();
        GlobalCall.globaleStudentList = studentList;

        if (GlobalCall.socialPragmatics.categoryData.length == 0) {
          bool isLoad = await preLoadApi.fetchPreLoad();
          if (!isLoad) {
            yield state.copyWith( isLoading: false);
            yield MainScreenStateFailure(error: 'Session Expired');
          }
        }
      } else {
        yield state.copyWith( isLoading: false);
        yield MainScreenStateFailure(error: 'Session Expired');
      }
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenStateFailure(error: error.toString());
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  //                      Get history
  //////////////////////////////////////////////////////////////////////////////

  Stream<MainScreenState> getHistory(String startDate, String endDate) async* {
    try {
      if (state.history.length == 0) {
        yield state.copyWith(isLoading: true);
      }
      List<HistoryModel> history = await historyApi.getHistoryList(
          sdate: startDate, endDate: endDate);
      yield state.copyWith(history: history, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenStateFailure(error: error.toString());
    }
  }

  Stream<MainScreenState> refreshHistory(String startDate, String endDate) async* {
    try {
      List<HistoryModel> history = await historyApi.getHistoryList(
          sdate: startDate, endDate: endDate);
      yield state.copyWith(history: history, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenStateFailure(error: error.toString());
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  //                      Get Progress
  //////////////////////////////////////////////////////////////////////////////

  Stream<MainScreenState> getProgress(String startDate, String endDate) async* {
    try {
      yield state.copyWith(isLoading: true);
      List<ProgressAmountModel> progress = await progressApi.getProgressAmountList(startDate, endDate);
      yield state.copyWith(progress: progress, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenStateFailure(error: error.toString());
    }
  }

  Stream<MainScreenState> refreshProgress(String startDate, String endDate) async* {
    try {
      List<ProgressAmountModel> progress = await progressApi.getProgressAmountList(startDate, endDate);
      yield state.copyWith(progress: progress, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenStateFailure(error: error.toString());
    }
  }
}