import 'package:aosny_services/api/add_session_api.dart';
import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/api/env.dart';
import 'package:aosny_services/api/session_api.dart';
import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/bloc/session_note/session_note.dart';
import 'package:aosny_services/bloc/session_note/session_note_event.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionNoteScreenBloc extends Bloc<SessionNoteScreenEvent, SessionNoteScreenState> {
  AddSessionApi addSessionNoteApi = new AddSessionApi();
  CompleteSessionApi completeSessionApi = new CompleteSessionApi();
  SessionApi _sessionApi = SessionApi();

  SessionNoteScreenBloc(SessionNoteScreenState initialState) : super(initialState);

  SessionNoteScreenState get initialState {
    return SessionNoteScreenState(isLoading: true);
  }

  @override
  Stream<SessionNoteScreenState> mapEventToState(
      SessionNoteScreenEvent event,) async* {
    if (event is SessionNoteScreenInitEvent) {
      yield state.copyWith(
        student: event.student,
        selectedStudentName: event.selectedStudentName,
        eventType: event.eventType,
        noteText: event.noteText,
        sessionNotes: event.sessionNotes,
        sessionId: event.sessionId,
      );
      yield* loadInitialData(event.studentId);
    } else if (event is UpdateSelectedShortTerms) {
      yield state.copyWith(selectedShortTermResultListModel: event.selectedShortTermResultListModel);
    } else if (event is UpdateActivityListItem) {
      yield state.copyWith(activitiesListItems: event.activitiesListItems);
    } else if (event is SelectLongTermID) {
      yield state.copyWith(selectedLtGoalId: event.id);
    } else if (event is SaveSessionNoteEvent) {
      yield* saveSessionNote(event.url, event.completeSessionNotes);
    }
  }

  Stream<SessionNoteScreenState> loadInitialData(int studentId) async* {
    try {
      List<LongTermGpDropDownModel> longTermGpDropDownList = await _sessionApi.getLongTermGpDropDownList(studentId);
      List<ShortTermGpModel> shortTermGpList = await _sessionApi.getShortTermGpList(studentId);

      List<CheckList> gPcheckListItems = [];
      List<CategoryTextAndID> sPcheckListItems = [];
      List<CategoryTextAndID> sIcheckListItems = [];
      List<CategoryTextAndID> cAcheckListItems = [];
      List<CategoryTextAndID> jAcheckListItems = [];
      List<CategoryTextAndID> outComesListItems = [];
      Map<int, List<CheckList>> activitiesListItems = {};
      List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];
      int selectedLtGoalId = 0;

      shortTermGpList.map((ShortTermGpModel model) {
        gPcheckListItems.add(
            CheckList(title: model.shortgoaltext, checkVal: false, id: model.shortgoalid)
        );
      });
      if (GlobalCall.socialPragmatics.categoryData.length > 0) {
        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID
              .forEach((element) {
            sPcheckListItems.add(element);
          });
        }

        if (GlobalCall.SEITIntervention.categoryData.length > 0) {
          GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID
              .forEach((element) {
            sIcheckListItems.add(element);
          });
        }

        if (GlobalCall.completedActivity.categoryData.length > 0) {
          GlobalCall.completedActivity.categoryData[0].categoryTextAndID
              .forEach((element) {
            cAcheckListItems.add(element);
          });
        }

        if (GlobalCall.jointAttention.categoryData.length > 0) {
          GlobalCall.jointAttention.categoryData[0].categoryTextAndID.forEach((
              element) {
            jAcheckListItems.add(element);
          });
        }

        if (GlobalCall.outcomes.categoryData.length > 0) {
          GlobalCall.outcomes.categoryData[0].categoryTextAndID.forEach((
              element) {
            outComesListItems.add(element);
          });
        }

        if (GlobalCall.activities.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.activities.categoryData[0]
              .categoryTextAndID) {
            List<CheckList> list = [];
            list.add(
                CheckList(
                  title: data.categoryTextDetail,
                  checkVal: false,
                  id: data.categoryTextID,
                )
            );
            for (SubCategoryData subData in data.subCategoryData) {
              list.add(
                  CheckList(
                    title: subData.subCategoryTextDetail,
                    checkVal: false,
                    id: subData.subCategoryTextID,
                  )
              );
            }
            activitiesListItems[data.categoryTextID] = list;
          }
        }
        for (int i = 0; i < shortTermGpList.length; i++) {
          if (shortTermGpList[i].longGoalID == longTermGpDropDownList[0].longGoalID) {
            selectedShortTermResultListModel.add(
                SelectedShortTermResultListModel(
                  id: shortTermGpList[i].shortgoalid,
                  selectedId: shortTermGpList[i].longGoalID,
                  selectedShortgoaltext: shortTermGpList[i].shortgoaltext,
                  checkVal: false,
                )
            );
          }
        }
      }
      if (longTermGpDropDownList.length > 0 ) {
        selectedLtGoalId = longTermGpDropDownList[0].longGoalID;
      }

      yield state.copyWith(
        isLoading: state.sessionId != null,
        longTermGpDropDownList: longTermGpDropDownList,
        selectedLtGoalId: selectedLtGoalId,
        shortTermGpList: shortTermGpList,
        gPcheckListItems: gPcheckListItems,
        sPcheckListItems: sPcheckListItems,
        sIcheckListItems: sIcheckListItems,
        cAcheckListItems: cAcheckListItems,
        jAcheckListItems: jAcheckListItems,
        outComesListItems: outComesListItems,
        activitiesListItems: activitiesListItems,
        selectedShortTermResultListModel: selectedShortTermResultListModel,
      );

      if (state.sessionId != null) {
        String url = baseURL + 'SessionNote/${state.sessionId}/CompleteSessionNote';
        CompleteSessionNotes completeSessionNotes = await completeSessionApi.getSessionDetails(url);
        List<Goals> goals = completeSessionNotes.goals;
        if (goals.length > 0) {
          selectedLtGoalId = goals[0].longGoalID;
        } else {
          selectedLtGoalId = longTermGpDropDownList[0].longGoalID;
        }
        List<Activities> activities = completeSessionNotes.activities;
        for(int i = 0; i < shortTermGpList.length; i++){
          if(shortTermGpList[i].longGoalID == selectedLtGoalId){
            bool isSelect = false;
            if (goals.length > 0) {
              goals.forEach((element) {
                element.shortGoalIDs.forEach((element) {
                  if (element.shortGoalID == shortTermGpList[i].shortgoalid) {
                    isSelect = true;
                  }
                });
              });
            }
            selectedShortTermResultListModel.add(
              SelectedShortTermResultListModel(
                id: shortTermGpList[i].shortgoalid,
                selectedId: shortTermGpList[i].longGoalID,
                selectedShortgoaltext: shortTermGpList[i].shortgoaltext,
                checkVal: isSelect,
              ),
            );
          }
        }
        for (CategoryTextAndID data in GlobalCall.activities.categoryData[0].categoryTextAndID){
          List<CheckList> list = [];
          list.add(
              CheckList(
                title: data.categoryTextDetail,
                checkVal: true,
                id: data.categoryTextID,
              )
          );
          for (SubCategoryData subData in data.subCategoryData) {
            bool isSelect = false;
            if (activities.length > 0) {
              activities.forEach((element) {
                if (element.categoryDetailID == data.categoryTextID && element.activityDetailID == subData.subCategoryTextID) {
                  isSelect = true;
                }
              });
            }
            list.add(
                CheckList(
                  title: subData.subCategoryTextDetail,
                  checkVal: isSelect,
                  id: subData.subCategoryTextID,
                )
            );
          }
          activitiesListItems[data.categoryTextID] = list;
        }

        yield state.copyWith(
          isLoading: false,
          sessionNotes: completeSessionNotes,
          selectedLtGoalId: selectedLtGoalId,
          activitiesListItems: activitiesListItems,
        );
      }

    } catch (error) {
      yield SessionNoteScreenStateFailure(error: error.toString());
    }
  }


  Stream<SessionNoteScreenState> saveSessionNote(String url, CompleteSessionNotes completeSessionNotes) async* {
    AddSessionResponse responseAddSession = await addSessionNoteApi.addSessionDetails(url, body: completeSessionNotes.toJson());
  }

}