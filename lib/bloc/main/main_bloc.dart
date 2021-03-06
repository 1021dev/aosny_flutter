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
    } else if (event is UpdateSortFilterEvent) {
      yield* filterHistory();
    } else if (event is UpdateFilterProgressEvent) {
      yield* filterProgress();
    } else if (event is UpdatedSessionNoteEvent) {
      yield state.copyWith(isLoading: true);
      yield* refreshHistory(event.startDate, event.endDate);
    }
  }

  Stream<MainScreenState> loadInitialData() async* {
    try {
      yield state.copyWith(isLoading: true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      GlobalCall.name =  prefs.getString('userName');
      var jwt = token.split(".");
      var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
      GlobalCall.email =  payload['email'];

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
      if (history.length > 0) history.sort((a,b) => a.starttime.compareTo(b.starttime));
      yield state.copyWith(history: history, isLoading: false);
      add(UpdateSortFilterEvent());
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
    }
  }

  Stream<MainScreenState> refreshHistory(String startDate, String endDate) async* {
    try {
      List<HistoryModel> history = await historyApi.getHistoryList(
          sdate: startDate, endDate: endDate);
      if (history.length > 0) history.sort((a,b) => a.starttime.compareTo(b.starttime));
      yield state.copyWith(history: history, isLoading: false);
      add(UpdateSortFilterEvent());
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
    }
  }

  Stream<MainScreenState> filterHistory() async* {
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
      yield state.copyWith(filterHistory: filter, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
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
      add(UpdateFilterProgressEvent());
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
    }
  }

  Stream<MainScreenState> refreshProgress(String startDate, String endDate) async* {
    try {
      List<ProgressAmountModel> progress = await progressApi.getProgressAmountList(startDate, endDate);
      yield state.copyWith(progress: progress, isLoading: false);
      add(UpdateFilterProgressEvent());
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
    }
  }

  Stream<MainScreenState> filterProgress() async* {
    try {
      List<ProgressAmountModel> progress = [];
      List<ProgressAmountModel> filter = [];
      progress.addAll(state.progress);
      if (progress.length > 0) {

        if (GlobalCall.filterStudents && GlobalCall.student != '') {
          filter = progress.where((element) {
            String name = element.student;
            List list = name.split(', ');
            if (GlobalCall.student.contains(list.first) && GlobalCall.student.contains(list.last)) {
              return true;
            } else {
              return false;
            }
          }).toList();
        } else {
          filter = progress;
        }
        // if (GlobalCall.filterSessionTypes && GlobalCall.sessionType != '') {
        //   filter = filter.where((element) => element.sessionType == GlobalCall.sessionType).toList();
        // }
      }
      yield state.copyWith(filterProgress: filter, isLoading: false);
    } catch (error) {
      yield state.copyWith( isLoading: false);
      yield MainScreenEmptyData(error: error.toString());
    }
  }

}