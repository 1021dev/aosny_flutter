import 'package:aosny_services/api/add_session_api.dart';
import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/api/delete_session_api.dart';
import 'package:aosny_services/api/env.dart';
import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/api/session_api.dart';
import 'package:aosny_services/bloc/session_note/session_note.dart';
import 'package:aosny_services/bloc/session_note/session_note_event.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/missed_session_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionNoteScreenBloc extends Bloc<SessionNoteScreenEvent, SessionNoteScreenState> {
  AddSessionApi addSessionNoteApi = new AddSessionApi();
  DeleteSessionApi deleteSessionApi = new DeleteSessionApi();
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
      DateTime selectedDate = await getSessionDate(event.studentId);

      yield state.copyWith(
        student: event.student,
        selectedStudentName: event.selectedStudentName,
        eventType: event.eventType,
        noteText: event.noteText,
        sessionNotes: event.sessionNotes,
        sessionId: event.sessionId,
        selectedDate: selectedDate,
      );
      yield* loadInitialData(event.studentId);
    } else if (event is UpdateSelectedShortTerms) {
      yield state.copyWith(selectedShortTermResultListModel: event.selectedShortTermResultListModel);
    } else if (event is UpdateSelectedShortTerms2) {
      yield state.copyWith(selectedShortTermResultListModel2: event.selectedShortTermResultListModel);
    } else if (event is UpdateActivityListItem) {
      yield state.copyWith(activitiesListItems: event.activitiesListItems);
    } else if (event is SelectLongTermID) {
      List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];

      for(int i = 0; i< state.shortTermGpList.length; i++){
        bool isContain = false;
        selectedShortTermResultListModel.forEach((element) {
          if (element.id == state.shortTermGpList[i].shortgoalid) {
            isContain = true;
          }
        });
        if (!isContain) {
          if(state.shortTermGpList[i].longGoalID == event.id){
            selectedShortTermResultListModel.add(
                SelectedShortTermResultListModel(
                  id: state.shortTermGpList[i].shortgoalid,
                  selectedId: state.shortTermGpList[i].longGoalID,
                  selectedShortgoaltext: state.shortTermGpList[i].shortgoaltext,
                  checkVal: false,
                )
            );
          }
        }
      }
      yield state.copyWith(selectedLtGoalId: event.id, selectedShortTermResultListModel: selectedShortTermResultListModel);
    } else if (event is SelectLongTermID2) {
      List<SelectedShortTermResultListModel> selectedShortTerm2 = [];

      for(int i = 0; i< state.shortTermGpList.length; i++){
        bool isContain = false;
        selectedShortTerm2.forEach((element) {
          if (element.id == state.shortTermGpList[i].shortgoalid) {
            isContain = true;
          }
        });
        if (!isContain) {
          if (state.shortTermGpList[i].longGoalID == event.id) {
            selectedShortTerm2.add(
                SelectedShortTermResultListModel(
                  id: state.shortTermGpList[i].shortgoalid,
                  selectedId: state.shortTermGpList[i].longGoalID,
                  selectedShortgoaltext: state.shortTermGpList[i].shortgoaltext,
                  checkVal: false,
                )
            );
          }
        }
      }
      yield state.copyWith(selectedLtGoalId2: event.id, selectedShortTermResultListModel2: selectedShortTerm2);

    } else if (event is SaveSessionNoteEvent) {
      yield state.copyWith(noteText: event.noteText, activityChildPerformance: event.activityText, followUp: event.followText);
      yield* saveSessionNote(event.noteText);
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
      int finalNumber = state.finalNumber;
      DateTime dateTime = state.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
      DateTime currentEndDate = dateTime.add(Duration(minutes: finalNumber));
      List conflicts = getConflicts(dateTime, finalNumber, state.timeList);
      print(state.timeList);
      print(state.finalNumber);
      print(conflicts.first);
      print(conflicts.last);
      yield state.copyWith(selectedDate: dateTime, endDateTime: currentEndDate, exceedMandate: conflicts[0], conflictTime: conflicts[1], showAlert: true);
      // if (state.sessionType == sessionTypeStrings[1]) {
      //   add(GetMissedSessionEvent());
      // }
    } else if (event is UpdateSelectedDate) {
      int finalNumber = state.finalNumber;
      DateTime dateTime = event.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalNumber));
      final format = DateFormat('yy-MM-dd');
      String dateString = format.format(dateTime);
      TimeList response = await completeSessionApi.getTimeList(state.student.studentID.toInt(), '20$dateString');
      List conflicts = getConflicts(dateTime, finalNumber, response);
      print(state.timeList);
      print(state.finalNumber);
      print(conflicts.first);
      print(conflicts.last);
      final historyFormat = DateFormat('MM/dd/20yy');
      String historyDate = historyFormat.format(dateTime);
      add(GetSessionsOnDayEvent(date: historyDate));
      yield state.copyWith(selectedDate: dateTime, endDateTime: endDate, exceedMandate: conflicts[0], conflictTime: conflicts[1], showAlert: true, timeList: response);
    } else if (event is UpdateFinalNumber) {
      int finalNumber = event.finalNumber;
      DateTime dateTime = state.selectedDate ?? DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalNumber));
      // if (state.sessionType == sessionTypeStrings[1]) {
      //   add(GetMissedSessionEvent());
      // }
      List conflicts = getConflicts(dateTime, finalNumber, state.timeList);
      print(state.timeList);
      print(state.finalNumber);
      print(conflicts.first);
      print(conflicts.last);
      yield state.copyWith( finalNumber: finalNumber, endDateTime: endDate, exceedMandate: conflicts[0], conflictTime: conflicts[1], showAlert: true);
    } else if (event is UpdateLocation) {
      yield state.copyWith(location: event.location);
    } else if (event is UpdateLocation1) {
      yield state.copyWith(location1: event.location1);
    } else if (event is UpdateSchoolGroup) {
      yield state.copyWith(groupType: event.groupType);
    } else if (event is UpdateDropdownValue) {
      yield state.copyWith(dropDownValue: event.longGoalText);
    } else if (event is UpdateDropdownValue2) {
      yield state.copyWith(dropDownValue2: event.longGoalText);
    } else if (event is UpdateCheckedValue) {
      yield state.copyWith(checkedValue: event.checkedValue);
    } else if (event is UpdateSpCheckValue) {
      yield state.copyWith(sPcheckListItems: event.list);
    } else if (event is UpdateSiCheckValue) {
      yield state.copyWith(sIcheckListItems: event.list);
    } else if (event is UpdateOutComeIndex) {
      yield state.copyWith(selectedOutComesIndex: event.selectedOutComesIndex);
    } else if (event is UpdateOutComeIndex2) {
      yield state.copyWith(selectedOutComesIndex2: event.selectedOutComesIndex);
    } else if (event is UpdateSessionType) {
      yield state.copyWith(sessionType: event.sessionType);
      if (event.sessionType == sessionTypeStrings[1]) {
        add(GetMissedSessionEvent());
      }
    } else if (event is UpdateCAIndex) {
      yield state.copyWith(selectedCAIconIndex: event.selectedCAIconIndex);
    } else if (event is UpdateJAIndex) {
      yield state.copyWith(selectedJAIconIndex: event.selectedJAIconIndex);
    } else if (event is UpdateSessionNoteEvent) {
      yield state.copyWith(noteText: event.note, cptCodeList: []);
    } else if (event is UpdateProgText) {
      yield state.copyWith(selectedProgText: event.progText, noteText: '', cptCodeList: []);
    } else if (event is UpdateCptText1) {
      print(event.cptCodeList);
      yield state.copyWith(cptCodeList: event.cptCodeList, noteText: '',);
    } else if (event is DeleteSessionEvent) {
      yield* deleteSession(event.id);
    } else if (event is GetMissedSessionEvent) {
      var selectedDate1 = new DateFormat('MM/dd/yy');
      var selectedDate2 = new DateFormat('hh:mm a');

      String dateFinal =  selectedDate1.format(state.selectedDate);
      String sessionTime = selectedDate2.format(state.selectedDate);
      int duration = state.finalNumber;
      int studentId = state.student.studentID.toInt();
      yield* getMissedSessions(dateFinal, sessionTime, duration, studentId);
    } else if (event is UpdateMakeUpSessionId) {
      yield state.copyWith(mCalId: event.id);
    } else if (event is GetSessionTimeEvent) {
      DateTime dateTime = event.dateTime;
      final format = DateFormat('yy-MM-dd');
      String dateString = format.format(dateTime);
      print(dateTime);
      print(dateString);
      yield* getSessionTime('20$dateString');
    } else if (event is UpdateActivityChildPerformanceEvent) {
      yield state.copyWith(activityChildPerformance: event.note);
    } else if (event is UpdateFollowUpEvent) {
      yield state.copyWith(followUp: event.note);
    } else if (event is GetSessionsOnDayEvent) {
      yield* getSessionsOnDay(event.date);
    }

  }

  Stream<SessionNoteScreenState> loadInitialData(int studentId) async* {
    yield state.copyWith(isLoading: true);
    try {
      List<LongTermGpDropDownModel> longTermGpDropDownList = await _sessionApi.getLongTermGpDropDownList(studentId);
      List<ShortTermGpModel> temp = await _sessionApi.getShortTermGpList(studentId);
      List<ShortTermGpModel> shortTermGpList = [];
      temp.forEach((element) {
        bool isContain = false;
        shortTermGpList.forEach((element1) {
          if (element.longGoalID == element1.longGoalID && element.shortgoalid == element1.shortgoalid) {
            isContain = true;
          }
        });
        if (!isContain) {
          shortTermGpList.add(element);
        }
      });

      List<CheckList> gPcheckListItems = [];
      List<CategoryTextAndID> spListItems = [];
      List<CategoryTextAndID> siListItems = [];
      List<CheckList> sPcheckListItems = [];
      List<CheckList> sIcheckListItems = [];
      List<CategoryTextAndID> cAcheckListItems = [];
      List<CategoryTextAndID> jAcheckListItems = [];
      List<CategoryTextAndID> outComesListItems = [];
      Map<int, List<CheckList>> activitiesListItems = {};
      List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];
      List<SelectedShortTermResultListModel> selectedShortTermResultListModel2 = [];
      int selectedLtGoalId = -1;
      int selectedLtGoalId2 = -1;

      shortTermGpList.map((ShortTermGpModel model) {
        gPcheckListItems.add(
            CheckList(title: model.shortgoaltext, checkVal: false, id: model.shortgoalid)
        );
      });
      if (GlobalCall.socialPragmatics.categoryData.length > 0) {
        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID
              .forEach((element) {
            sPcheckListItems.add(CheckList(
              id: element.categoryTextID,
              title: element.categoryTextDetail,
              checkVal: false,
            ));
            spListItems.add(element);
          });
        }

        if (GlobalCall.SEITIntervention.categoryData.length > 0) {
          GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID
              .forEach((element) {
            sIcheckListItems.add(CheckList(
              id: element.categoryTextID,
              title: element.categoryTextDetail,
              checkVal: false,
            ));
            siListItems.add(element);
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

      if (state.sessionId == null) {
        DateTime dateTime = DateTime.now();
        final format = DateFormat('yy-MM-dd');
        String dateString = format.format(dateTime);
        print(dateTime);
        print(dateString);
        yield* getSessionTime('20$dateString');
        final historyFormat = DateFormat('MM/dd/20yy');
        String historyDate = historyFormat.format(dateTime);
        add(GetSessionsOnDayEvent(date: historyDate));

        yield state.copyWith(
          isLoading: state.sessionId != null,
          isSaving: false,
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
          selectedShortTermResultListModel2: selectedShortTermResultListModel2,
          sessionType: sessionTypeStrings[0],
          showAlert: true,
        );
      } else {
        selectedShortTermResultListModel.clear();
        selectedShortTermResultListModel2.clear();

        String url = baseURL + 'SessionNote/${state.sessionId}/CompleteSessionNote';
        CompleteSessionNotes completeSessionNotes = await completeSessionApi.getSessionDetails(url);
        List<Goals> goals = completeSessionNotes.goals;
        if (goals.length > 0) {
          selectedLtGoalId = goals[0].longGoalID;
          if (goals.length > 1) {
            selectedLtGoalId2 = goals[1].longGoalID;
          }
        } else {
        }
        List<Activities> activities = completeSessionNotes.activities;
        for(int i = 0; i < shortTermGpList.length; i++){
          if(shortTermGpList[i].longGoalID == selectedLtGoalId){
            bool isSelect = false;
            if (goals.length > 0) {
              goals[0].shortGoalIDs.forEach((element) {
                if (element.shortGoalID == shortTermGpList[i].shortgoalid) {
                  isSelect = true;
                }
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
          if(shortTermGpList[i].longGoalID == selectedLtGoalId2){
            bool isSelect = false;
            if (goals.length > 1) {
              goals[1].shortGoalIDs.forEach((element) {
                if (element.shortGoalID == shortTermGpList[i].shortgoalid) {
                  isSelect = true;
                }
              });
            }
            selectedShortTermResultListModel2.add(
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

        List<MissedSessionModel> missedSession = [];
        int settingsGroupOrNot;
        String sessionDateTime, sessionTime, duration, sessionEndTime, location, location1, sessionType;
        String dropDownValue;
        String dropDownValue2;
        bool checkedValue;
        int groupType;
        DateTime selectedDate;
        DateTime toPassDate,endDateTime;
        int selectedSPIndex;
        int selectedSIIndex;
        int selectedOutComesIndex = -1;
        int selectedOutComesIndex2 = -1;
        int selectedCAIconIndex;
        int selectedJAIconIndex;

        int finalNumber;

        checkedValue = completeSessionNotes.confirmed == 1;

        String noteText =  completeSessionNotes.notes ?? '';

        String locationHomeOrSchool = completeSessionNotes.location ?? '';
        List<String> locations = locationHomeOrSchool.split('|').toList();
        location = locations.first;
        location1 = locations[1];
        sessionType = completeSessionNotes.sessionType ?? sessionTypeStrings[0];
        settingsGroupOrNot = completeSessionNotes.manDateType;

        groupType = settingsGroupOrNot ?? 1;

        duration =  completeSessionNotes.duration.toString();
        finalNumber = completeSessionNotes.duration;
        sessionDateTime = '${completeSessionNotes.sessionDate} ${completeSessionNotes.sessionTime}';
        toPassDate = new DateFormat('MM/dd/yy HH:mm:ss').parse(sessionDateTime);
        sessionTime = DateFormat.jm().format(toPassDate);
        selectedDate = toPassDate;

        endDateTime =  toPassDate.add(Duration(minutes: int.parse(duration)));

        sessionEndTime = DateFormat.jm().format(endDateTime);
        if (selectedLtGoalId > -1) {
          List<LongTermGpDropDownModel> models = longTermGpDropDownList.where((element) => element.longGoalID == selectedLtGoalId).toList();
          if (models.length > 0) {
            dropDownValue = models[0].longGoalText;
          }
        }
        if (selectedLtGoalId2 > -1) {
          List<LongTermGpDropDownModel> models = longTermGpDropDownList.where((element) => element.longGoalID == selectedLtGoalId2).toList();
          if (models.length > 0) {
            dropDownValue2 = models[0].longGoalText;
          }
        }
        List<SessionNoteExtrasList> sessionNotesExtras = completeSessionNotes.sessionNoteExtrasList;

        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          if (GlobalCall.socialPragmatics.categoryData.length > 0) {
            sPcheckListItems.clear();
            for (CategoryTextAndID data in GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID){
              bool hasvalue = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.socialPragmatics.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      hasvalue = true;
                    }
                  }
                });
              }
              sPcheckListItems.add(CheckList(id: data.categoryTextID, title: data.categoryTextDetail, checkVal: hasvalue));
            }
          }

          if (GlobalCall.SEITIntervention.categoryData.length > 0) {
            sIcheckListItems.clear();
            for (CategoryTextAndID data in GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID){
              bool hasvalue = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.SEITIntervention.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      hasvalue = true;
                    }
                  }
                });
              }
              sIcheckListItems.add(CheckList(id: data.categoryTextID, title: data.categoryTextDetail, checkVal: hasvalue));
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
                selectedCAIconIndex = cAcheckListItems.indexOf(temp) ?? -1;
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
                selectedJAIconIndex = jAcheckListItems.indexOf(temp) ?? -1;
              }
            }
          }

          if (GlobalCall.outcomes.categoryData.length > 0) {
            if (goals.length > 0) {
              for (CategoryTextAndID data in GlobalCall.outcomes.categoryData[0].categoryTextAndID){
                CategoryTextAndID temp;
                if (sessionNotesExtras.length > 0) {
                  sessionNotesExtras.forEach((element) {
                    if (element.sNECategoryID == GlobalCall.outcomes.categoryData[0].mainCategoryID) {
                      if (element.sNESubDetailID == data.categoryTextID && element.sNECategoryDetailID == goals[1].longGoalID) {
                        temp = data;
                      }
                    }
                  });
                }
                if (temp != null) {
                  print('oucCome $temp');
                  selectedOutComesIndex = outComesListItems.indexOf(temp) ?? -1;
                }
              }
              if (goals.length > 1) {
                for (CategoryTextAndID data in GlobalCall.outcomes.categoryData[0].categoryTextAndID){
                  CategoryTextAndID temp;
                  if (sessionNotesExtras.length > 0) {
                    sessionNotesExtras.forEach((element) {
                      if (element.sNECategoryID == GlobalCall.outcomes.categoryData[0].mainCategoryID) {
                        if (element.sNESubDetailID == data.categoryTextID && element.sNECategoryDetailID == goals[1].longGoalID) {
                          temp = data;
                        }
                      }
                    });
                  }
                  if (temp != null) {
                    print('oucCome $temp');
                    selectedOutComesIndex2 = outComesListItems.indexOf(temp) ?? -1;
                  }
                }
              }
            }
          }
        }

        String activityChildPerformance = '';
        String followUp = '';
        if (completeSessionNotes.sessionType == sessionTypesForState().last && completeSessionNotes.progId == 3) {
          List<String> tempNotes = completeSessionNotes.notes.split('~');
          if (tempNotes.length > 0) {
            activityChildPerformance = tempNotes.first;
          }
          if (tempNotes.length > 1) {
            followUp = tempNotes.last;
          }
        }
        missedSession = completeSessionNotes.singleMakeupSessionNote;
        DateTime dateTime = selectedDate;
        final format = DateFormat('yy-MM-dd');
        String dateString = format.format(dateTime);
        print(dateTime);
        print(dateString);
        yield* getSessionTime('20$dateString');
        final historyFormat = DateFormat('MM/dd/20yy');
        String historyDate = historyFormat.format(dateTime);
        add(GetSessionsOnDayEvent(date: historyDate));

        yield state.copyWith(
          isLoading: false,
          isSaving: false,
          longTermGpDropDownList: longTermGpDropDownList,
          shortTermGpList: shortTermGpList,
          sessionNotes: completeSessionNotes,
          sPcheckListItems: sPcheckListItems,
          sIcheckListItems: sIcheckListItems,
          selectedLtGoalId: selectedLtGoalId,
          selectedLtGoalId2: selectedLtGoalId2,
          activitiesListItems: activitiesListItems,
          selectedShortTermResultListModel: selectedShortTermResultListModel,
          selectedShortTermResultListModel2: selectedShortTermResultListModel2,
          noteText: noteText,
          location: location,
          location1: location1,
          sessionType: sessionType,
          checkedValue: checkedValue,
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
          dropDownValue2: dropDownValue2,
          selectedSPIndex: selectedSPIndex,
          selectedSIIndex: selectedSIIndex,
          selectedCAIconIndex: selectedCAIconIndex,
          selectedJAIconIndex: selectedJAIconIndex,
          selectedOutComesIndex: selectedOutComesIndex,
          selectedOutComesIndex2: selectedOutComesIndex2,
          selectedProgText: completeSessionNotes.progText,
          confirmedVal: completeSessionNotes.confirmed,
          cptText: completeSessionNotes.cptText,
          cptCodeList: completeSessionNotes.cptCodeList,
          gPcheckListItems: gPcheckListItems,
          cAcheckListItems: cAcheckListItems,
          jAcheckListItems: jAcheckListItems,
          outComesListItems: outComesListItems,
          missedSessions: missedSession,
          isLock: false,
          mCalId: completeSessionNotes.mCalId,
          showAlert: false,
          activityChildPerformance: activityChildPerformance,
          followUp: followUp,
        );
      }
    } catch (error) {
      print(error);
      yield state.copyWith(isLoading: false, isSaving: false);
      yield SessionNoteScreenStateFailure(error: error.toString());
    }
  }


  Stream<SessionNoteScreenState> saveSessionNote(String noteText) async* {
    yield state.copyWith(isSaving: true, noteText: noteText);
    var selectedDate1 = new DateFormat('MM/dd/yy');
    var selectedDate2 = new DateFormat('hh:mm a');

    String dateFinal =  selectedDate1.format(state.selectedDate);

    String sessionTime = selectedDate2.format(state.selectedDate);
    String sessionDateTime = dateFinal;

    String locationHomeOrSchool = '${state.location}|${state.location1 ?? '(Sel)'}';


    String url =  state.sessionId != null ? baseURL + 'SessionNote/${state.sessionId}/CompleteSessionNote': baseURL + 'SessionNote/0/CompleteSessionNote';

    List<Goals> goals = [];
    List<ShortGoalIDs> shortTerms  = [];
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerms.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    List<ShortGoalIDs> shortTerms2  = [];
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel2) {
      if (model.checkVal) {
        shortTerms2.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    if (state.selectedLtGoalId > -1) {
      var goal = Goals(longGoalID: state.selectedLtGoalId, shortGoalIDs: shortTerms);
      goals.add(goal);
    }
    if (state.selectedLtGoalId2 > -1) {
      var goal2 = Goals(longGoalID: state.selectedLtGoalId2, shortGoalIDs: shortTerms2);
      goals.add(goal2);
    }
    List<SessionNoteExtrasList> sessionNoteExtrasList = [];

    state.sPcheckListItems.forEach((element) {
      if (element.checkVal) {
        sessionNoteExtrasList.add(
            SessionNoteExtrasList(sNECategoryID: GlobalCall.socialPragmatics.categoryData[0].mainCategoryID,
                sNECategoryDetailID: element.id,
                sNESubDetailID: 0));
      }
    });
    state.sIcheckListItems.forEach((element) {
      if (element.checkVal) {
        print(element.id);
        print(GlobalCall.SEITIntervention.categoryData[0].mainCategoryID);
        sessionNoteExtrasList.add(
            SessionNoteExtrasList(sNECategoryID: GlobalCall.SEITIntervention.categoryData[0].mainCategoryID,
                sNECategoryDetailID: element.id,
                sNESubDetailID: 0));
      }
    });
    if (state.selectedOutComesIndex > -1 && state.selectedLtGoalId > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.outcomes.categoryData[0].mainCategoryID,
              sNESubDetailID: state.outComesListItems[state.selectedOutComesIndex].categoryTextID,
              sNECategoryDetailID: state.selectedLtGoalId));
    }

    if (state.selectedOutComesIndex2 > -1 && state.selectedLtGoalId2 > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.outcomes.categoryData[0].mainCategoryID,
              sNESubDetailID: state.outComesListItems[state.selectedOutComesIndex2].categoryTextID,
              sNECategoryDetailID: state.selectedLtGoalId2));
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

    List<Activities> activities = [];
    state.activitiesListItems.forEach((key, alist) {
      for(int j = 1; j < alist.length; j++) {
        if (alist[j].checkVal) {
          activities.add(Activities(activityDetailID: alist[j].id, categoryDetailID: alist[0].id));
        }
      }
    });
    String progText = '';
    String cptText = '';
    if (state.sessionType == sessionTypeStrings[5]) {
      progText = state.selectedProgText;
      cptText = state.cptText;
    }
    int mCalId = 0;
    if (state.sessionType == sessionTypeStrings[1]) {
      mCalId = state.mCalId;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerid = prefs.getString('providerid');
    // String gNote = '';
    int progId = 0;
    int cptCode = -1;
    List<CptCode> cptCodeList = [];
    if (state.sessionType == sessionTypeStrings[5]) {
      if (state.selectedProgText != '' && state.selectedProgText != null) {
        int index = nonDirectActivities.indexOf(state.selectedProgText);
        switch (index) {
          case 0:
            progId = 3;
            cptCodeList = state.cptCodeList;
            noteText = (state.activityChildPerformance ?? '').trimRight() + ' ~ ' + (state.followUp ?? '').trimLeft();
            CptCode cid = cptCodeList.firstWhere((element) {
              return element.cptid < 6;
            });
            if (cid != null && cid.cptid > 01) {
              cptText = cptCodeId[cid.cptid - 1];
            }
            break;
          case 1:
            progId = 9;
            break;
          default:
            progId = 10;
            break;
        }

      }
    }
    if (state.sessionType == sessionTypeStrings[0] || state.sessionType == sessionTypeStrings[1]) {
      cptCode = 1;
    }
    AddSessionResponse newPost = new AddSessionResponse(
      providerId: providerid,
      studentID: state.student.studentID.toInt(),
      sessionDate: sessionDateTime,
      sessionTime: sessionTime,
      duration: state.finalNumber,
      group: state.groupType,
      manDateType: state.groupType,
      location: locationHomeOrSchool,
      sessionType: state.sessionType,
      notes: noteText,
      confirmed: 0,
      goals: goals,
      activities: activities,
      sessionID: state.sessionId ?? 0,
      progText: progText,
      cptText: cptText,
      cptCodeList: cptCodeList,
      cptCode: cptCode,
      progId: progId,
      sessionNoteExtrasList: sessionNoteExtrasList,
      xid: state.student.xid,
      mCalId: mCalId,
    );
    try {
      AddSessionResponse responseAddSession = await addSessionNoteApi.addSessionDetails(url, body: newPost.toJson());
      yield state.copyWith(isLoading: false);
      int h = state.selectedDate.hour;
      int m = state.selectedDate.minute;
      if (state.finalNumber == 30) {
        if ((m + 30) >= 60) {
          h = h + 1;
          m = m + 30 - 60;
        } else {
          m = m + 30;
        }
      } else {
        h = h + 1;
      }
      if ((state.sessionId ?? 0) == 0) {
        DateTime selectedDate = DateTime(state.selectedDate.year, state.selectedDate.month, state.selectedDate.day, h, m);
        await saveLastSessionDate(state.student.studentID.toInt(), selectedDate);
      }
      yield SessionNoteScreenStateSuccess(finalNumber: state.finalNumber,);
    } catch (error) {
      print(error.toString());
      yield state.copyWith(isLoading: false, isSaving: false);
    }
  }

  Stream<SessionNoteScreenState> deleteSession(int id) async* {
    try {
      yield state.copyWith(isSaving: true);
      dynamic response = await deleteSessionApi.deleteSession(id);
      yield state.copyWith(isLoading: false);
      yield SessionNoteScreenStateSuccess();
    } catch (error) {
      yield state.copyWith(isLoading: false, isSaving: false);
    }
  }

  Stream<SessionNoteScreenState> getMissedSessions(String date, String time, int duration, int studentId) async* {
    try {
      yield state.copyWith(isLoading: true);
      List<MissedSessionModel> response = await completeSessionApi.getMissedSessions(date, time, duration, studentId);
      yield state.copyWith(missedSessions: response, isLoading: false, mCalId: 0);
    } catch (error) {
      yield state.copyWith(isLoading: false, isSaving: false);
    }
  }

  Stream<SessionNoteScreenState> getSessionTime(String date) async* {
    try {
      yield state.copyWith(isLoading: true);
      TimeList response = await completeSessionApi.getTimeList(state.student.studentID.toInt(), date);
      List conflicts = getConflicts(state.selectedDate, state.finalNumber, response);
      print(state.timeList);
      print(state.finalNumber);
      print(conflicts.first);
      print(conflicts.last);
      yield state.copyWith(timeList: response, exceedMandate: conflicts[0], conflictTime: conflicts[1], isLoading: false);
    } catch (error) {
      yield state.copyWith(isLoading: false, isSaving: false);
    }
  }

  List getConflicts(DateTime dateTime, int duration, TimeList timeList) {
    if (timeList == null) {
      return [false, false];
    }
    DateTime currentDate = DateTime(dateTime.year == 20 ? dateTime.year + 2000: dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
    DateTime currentEndDate = currentDate.add(Duration(minutes: duration));
    bool exceedMandate = false;
    if (timeList.progressedList.length == 0) {
    } else {
      ProgressedTime progressedTime = timeList.progressedList.firstWhere((element) {
        return element.studentId == state.student.studentID.toInt();
      });
      if (progressedTime != null && state.sessionType != sessionTypeStrings[5]) {
        int weekMins = progressedTime.weekMins + duration;
        exceedMandate = weekMins > progressedTime.mandateMins;
      }
    }
    bool isConflict = false;
    if (timeList.timeList.length == 0) {

    } else {
      timeList.timeList.forEach((element) {
        if (element.sessionId != state.sessionId) {
          final formatDate = DateFormat('M/d/yyyy hh:mm:ss a');
          String startTimeString = element.startTime;
          DateTime startDate = formatDate.parse(startTimeString);
          DateTime endDate = startDate.add(Duration(minutes: element.dur));
          if (element.sessionType == sessionTypesForState()[sessionTypesForState().length - 4] || element.sessionType == sessionTypesForState()[sessionTypesForState().length - 2]) {
          } else {
            if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate)) {
              isConflict = true;
              return;
            } else if (currentEndDate.isAfter(startDate) && currentEndDate.isBefore(endDate)) {
              isConflict = true;
              return;
            } else if (currentDate.isBefore(startDate) && currentEndDate.isAfter(endDate)) {
              isConflict = true;
              return;
            } else if (currentDate.isAtSameMomentAs(startDate) && currentEndDate.isAtSameMomentAs(endDate)) {
              isConflict = true;
              return;
            }
          }
        }
      });
      List<HistoryModel> sessionsOnDay = state.sessionOnDay;
      sessionsOnDay.forEach((element) {
        if (element.iD != state.sessionId) {
          final formatDate = DateFormat('yyyy-MM-ddThh:mm:ss');
          String startTimeString = element.starttime;
          DateTime startDate = formatDate.parse(startTimeString);
          DateTime endDate = startDate.add(Duration(minutes: element.nmin));
          if (element.sessionType == sessionTypesForState()[sessionTypesForState().length - 4] || element.sessionType == sessionTypesForState()[sessionTypesForState().length - 2]) {
          } else {
            if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate)) {
              isConflict = true;
              return;
            } else if (currentEndDate.isAfter(startDate) && currentEndDate.isBefore(endDate)) {
              isConflict = true;
              return;
            } else if (currentDate.isBefore(startDate) && currentEndDate.isAfter(endDate)) {
              isConflict = true;
              return;
            } else if (currentDate.isAtSameMomentAs(startDate) && currentEndDate.isAtSameMomentAs(endDate)) {
              isConflict = true;
              return;
            }
          }
        }
      });
    }
    return [exceedMandate, isConflict];
  }

  Future saveLastSessionDate(int student, DateTime dateTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print('last sessionDate saved ${dateTime.millisecondsSinceEpoch}');
    print('last student saved $student');

    preferences.setInt('lastSessionDate', dateTime.millisecondsSinceEpoch);
    preferences.setInt('lastStudentId', student);
  }

  Future<DateTime> getSessionDate(int student) async {
    DateTime now = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int last = preferences.getInt('lastSessionDate') ?? 0;
    int studentId = preferences.getInt('lastStudentId') ?? 0;

    print('last sessionDate open $last');
    print('last student open $studentId');

    if (last > 0) {
      DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(last);
      if (now.year == lastDate.year && now.month == lastDate.month && now.day == lastDate.day) {
        if (studentId != student) {
          now = DateTime(now.year, now.month, now.day, lastDate.hour, lastDate.minute + 1);
        } else {
          now = DateTime(now.year, now.month, now.day, lastDate.hour, lastDate.minute);
        }
      } else {
        now = DateTime(now.year, now.month, now.day, 9, 0);
      }
    } else {
      now = DateTime(now.year, now.month, now.day, 9, 0);
    }
    return now;
  }

  Stream<SessionNoteScreenState> getSessionsOnDay(String date) async* {
    try {
      yield state.copyWith(isLoading: true);
      List<HistoryModel> response = await HistoryApi().getHistoryList(sdate: date, endDate: date);
      if (response.length > 0) response.sort((a,b) => a.starttime.compareTo(b.starttime));

      int finalNumber = state.finalNumber;
      DateTime dateTime = state.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
      List conflicts = getConflicts(dateTime, finalNumber, state.timeList);
      print(state.timeList.timeList.length);
      print(state.finalNumber);
      print(conflicts.first);
      print(conflicts.last);
      yield state.copyWith(isLoading: false, sessionOnDay: response, exceedMandate: conflicts[0], conflictTime: conflicts[1]);
    } catch (error) {
      yield state.copyWith(isLoading: false, isSaving: false);
    }
  }

  List<String> sessionTypesForState() {
    if (state.exceedMandate) {
      return [
        'Service provided - Make-up',
        'Student Absent',
        'Provider Absent',
        'Student Unavailable',
        'Non-Direct Care',
      ];
    } else {
      return sessionTypeStrings;
    }
  }
}