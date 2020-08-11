import 'package:aosny_services/api/add_session_api.dart';
import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/api/env.dart';
import 'package:aosny_services/api/session_api.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      String showDate = DateFormat('EEEE, MMMM d').format(DateTime.now()).toString();
      TimeOfDay selectedTime = new TimeOfDay.now();
      DateTime selectedDate = DateTime.now();

      yield state.copyWith(
        student: event.student,
        selectedStudentName: event.selectedStudentName,
        eventType: event.eventType,
        noteText: event.noteText,
        sessionNotes: event.sessionNotes,
        sessionId: event.sessionId,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
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
    } else if (event is SelectGoalSection) {
      yield state.copyWith(goalsAndProgress: event.isSelect);
    } else if (event is SelectActivitySection) {
      yield state.copyWith(isActivities: event.isSelect);
    } else if (event is SelectSPSection) {
      yield state.copyWith(socialPragmaics: event.isSelect);
    } else if (event is SelectSISection) {
      yield state.copyWith(seitIntervention: event.isSelect);
    } else if (event is SelectCASection) {
      yield state.copyWith(competedActivites: event.isSelect);
    } else if (event is SelectJASection) {
      yield state.copyWith(jointAttentionEyeContact: event.isSelect);
    } else if (event is UpdateSelectedTime) {
      TimeOfDay timeOfDay = event.selectedTime;
      int finalnumber = state.finalNumber;
      DateTime dateTime = state.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalnumber));
      yield state.copyWith(selectedTime: timeOfDay, selectedDate: dateTime, endDateTime: endDate);
    } else if (event is UpdateSelectedDate) {
      int finalnumber = state.finalNumber;
      TimeOfDay timeOfDay = state.selectedTime;
      DateTime dateTime = event.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalnumber));
      yield state.copyWith(selectedTime: timeOfDay, selectedDate: dateTime, endDateTime: endDate);
    } else if (event is UpdateFinalNumber) {
      int finalnumber = event.finalNumber;
      TimeOfDay timeOfDay = state.selectedTime;
      DateTime dateTime = state.selectedDate ?? DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalnumber));
      yield state.copyWith(selectedTime: timeOfDay, finalNumber: event.finalNumber, endDateTime: endDate);
    } else if (event is UpdateHomeBuilding) {
      yield state.copyWith(isHome: event.isHome);
    } else if (event is UpdateSchoolGroup) {
      yield state.copyWith(groupType: event.groupType);
    } else if (event is UpdateDropdownValue) {
      yield state.copyWith(dropDownValue: event.longGoalText);
    } else if (event is UpdateCheckedValue) {
      yield state.copyWith(checkedValue: event.checkedValue);
    } else if (event is UpdateSPIndex) {
      yield state.copyWith(selectedSPIndex: event.selectedSPIndex);
    } else if (event is UpdateSIIndex) {
      yield state.copyWith(selectedSIIndex: event.selectedSIIndex);
    } else if (event is UpdateOutComeIndex) {
      yield state.copyWith(selectedOutComesIndex: event.selectedOutComesIndex);
    } else if (event is UpdateSessionType) {
      yield state.copyWith(selectedSessionTypeIndex: event.selectedSessionTypeIndex);
    } else if (event is UpdateCAIndex) {
      yield state.copyWith(selectedCAIconIndex: event.selectedCAIconIndex);
    } else if (event is UpdateJAIndex) {
      yield state.copyWith(selectedJAIconIndex: event.selectedJAIconIndex);
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

        int settingsGroupOrNot;
        String sessionDateTime, sessionTime, duration, sessionEndTime, locationHomeOrSchool, sessionType, sessionIDValue, confirmedVal;

        bool isHome;
        String dropDownValue;
        bool checkedValue;
        int groupType;
        DateTime selectedDate;
        DateTime toPassDate,endDateTime;
        int selectedSPIndex;
        int selectedSIIndex;
        int selectedOutComesIndex;
        int selectedCAIconIndex;
        int selectedJAIconIndex;
        int selectedSessionTypeIndex;

        TimeOfDay selectedTime;
        int finalNumber;


        String noteText =  completeSessionNotes.notes ?? '';

        locationHomeOrSchool = completeSessionNotes.location ?? '';
        sessionType =  completeSessionNotes.sessionType ?? 1;
        int index = sessionTypeStrings.indexOf(sessionType);
        if (index != null) {
          selectedSessionTypeIndex = index;
        }


        if(locationHomeOrSchool != null && locationHomeOrSchool.contains('School')){
          isHome = false;
        } else {
          isHome = true;
        }
        settingsGroupOrNot = completeSessionNotes.group;

        groupType = settingsGroupOrNot ?? 1;

        duration =  completeSessionNotes.duration.toString();
        finalNumber = completeSessionNotes.duration;
        sessionDateTime = '${completeSessionNotes.sessionDate} ${completeSessionNotes.sessionTime}';
        toPassDate = new DateFormat('MM/dd/yy hh:mm:ss').parse(sessionDateTime);
        sessionTime = DateFormat.jm().format(toPassDate);
        selectedDate = toPassDate;

        endDateTime =  toPassDate.add(Duration(days: 0, hours: 0, minutes: int.parse(duration)));

        sessionEndTime = DateFormat.jm().format(endDateTime);
        LongTermGpDropDownModel model = state.longTermGpDropDownList.firstWhere((element) => element.longGoalID == state.selectedLtGoalId);
        if (model != null) {
          dropDownValue = model.longGoalText;
        }
        List<SessionNoteExtrasList> sessionNotesExtras = completeSessionNotes.sessionNoteExtrasList;

        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          if (GlobalCall.socialPragmatics.categoryData.length > 0) {
            CategoryTextAndID temp;
            for (CategoryTextAndID data in GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID){
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.socialPragmatics.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
            }
            if (temp != null) {
              selectedSPIndex = state.sPcheckListItems.indexOf(temp) ?? -1;
            }
          }

          if (GlobalCall.SEITIntervention.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID){
              CategoryTextAndID temp;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.SEITIntervention.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
              if (temp != null) {
                selectedSIIndex = state.sIcheckListItems.indexOf(temp) ?? -1;
              }
            }
          }

          if (GlobalCall.completedActivity.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.completedActivity.categoryData[0].categoryTextAndID){
              CategoryTextAndID temp;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.completedActivity.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
              if (temp != null) {
                selectedCAIconIndex = state.cAcheckListItems.indexOf(temp) ?? -1;
              }
            }
          }

          if (GlobalCall.jointAttention.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.jointAttention.categoryData[0].categoryTextAndID){
              CategoryTextAndID temp;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.jointAttention.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
              if (temp != null) {
                selectedJAIconIndex = state.jAcheckListItems.indexOf(temp) ?? -1;
              }
            }
          }

          if (GlobalCall.outcomes.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.outcomes.categoryData[0].categoryTextAndID){
              CategoryTextAndID temp;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.outcomes.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
              if (temp != null) {
                selectedOutComesIndex = state.outComesListItems.indexOf(temp) ?? -1;
              }
            }
          }
        }

        yield state.copyWith(
          isLoading: false,
          sessionNotes: completeSessionNotes,
          selectedLtGoalId: selectedLtGoalId,
          activitiesListItems: activitiesListItems,
          noteText: noteText,
          locationHomeOrSchool:locationHomeOrSchool,
          sessionType: sessionType,
          selectedSessionTypeIndex: selectedSessionTypeIndex,
          isHome: isHome,
          settingsGroupOrNot: settingsGroupOrNot,
          groupType: groupType,
          duration: duration,
          finalNumber: finalNumber,
          sessionDateTime: sessionDateTime,
          toPassDate: toPassDate,
          sessionTime: sessionTime,
          selectedDate: selectedDate,
          endDateTime: endDateTime,
          sessionEndTime: sessionEndTime,
          dropDownValue: dropDownValue,
          selectedSPIndex: selectedSPIndex,
          selectedSIIndex: selectedSIIndex,
          selectedCAIconIndex: selectedCAIconIndex,
          selectedJAIconIndex: selectedJAIconIndex,
          selectedOutComesIndex: selectedOutComesIndex,
        );
      }

    } catch (error) {
      yield SessionNoteScreenStateFailure(error: error.toString());
    }
  }


  Stream<SessionNoteScreenState> saveSessionNote(String url, CompleteSessionNotes completeSessionNotes) async* {
    var selectedDate1 = new DateFormat('MM/dd/yy hh:mm:ss');

    String dateFinal =  selectedDate1.format(state.selectedDate);

    String sessionTime = DateFormat.jm().format(state.selectedDate);
    String sessionDateTime = dateFinal;

    String locationHomeOrSchool = state.isHome ? 'Home|Class': 'School|Class';


    String url =  state.sessionId != null ? baseURL + 'SessionNote/${state.sessionId}/CompleteSessionNote': baseURL + 'SessionNote/0/CompleteSessionNote';

    List<Goals> goals = List();
    List<ShortGoalIDs> shortTerms = List();
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerms.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    var goal = Goals(longGoalID: state.selectedLtGoalId, shortGoalIDs: shortTerms);
    goals.add(goal);
    List<SessionNoteExtrasList> sessionNoteExtrasList = [];

    if (state.selectedSPIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.socialPragmatics.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.sPcheckListItems[state.selectedSPIndex].categoryTextID,
              sNESubDetailID: 0));
    }
    if (state.selectedSIIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.SEITIntervention.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.sIcheckListItems[state.selectedSIIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (state.selectedOutComesIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.outcomes.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.outComesListItems[state.selectedOutComesIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (state.selectedCAIconIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.completedActivity.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.cAcheckListItems[state.selectedCAIconIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (state.selectedJAIconIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.jointAttention.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.jAcheckListItems[state.selectedJAIconIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    List<Activities> activities = List();
    state.activitiesListItems.forEach((key, alist) {
      for(int j = 1; j < alist.length; j++) {
        if (alist[j].checkVal) {
          activities.add(Activities(activityDetailID: alist[j].id, categoryDetailID: alist[0].id));
        }
      }
    });
    CompleteSessionNotes newPost = new CompleteSessionNotes(
      sessionDate: sessionDateTime,
      sessionTime: sessionTime,
      duration: state.finalNumber,
      group: state.groupType,
      location: locationHomeOrSchool,
      sessionType: state.sessionType,
      notes: state.noteText,
      confirmed: int.parse(state.confirmedVal),
      goals: goals,
      activities: activities,
      sessionID: 0,
      sessionNoteExtrasList: sessionNoteExtrasList,
    );
    AddSessionResponse responseAddSession = await addSessionNoteApi.addSessionDetails(url, body: newPost.toJson());
  }

}