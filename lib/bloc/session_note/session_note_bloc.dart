import 'package:aosny_services/api/add_session_api.dart';
import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/api/delete_session_api.dart';
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
      DateTime selectedDate = event.selectedTime != null ? event.selectedTime: new DateTime.now();
      TimeOfDay selectedTime = new TimeOfDay.now();

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
      int finalnumber = state.finalNumber;
      DateTime dateTime = state.selectedDate;
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
      DateTime endDate = dateTime.add(Duration(minutes: finalnumber));
      yield state.copyWith(selectedTime: timeOfDay, selectedDate: dateTime, endDateTime: endDate);
      if (state.selectedSessionTypeIndex == 1) {
        add(GetMissedSessionEvent());
      }
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
      if (state.selectedSessionTypeIndex == 1) {
        add(GetMissedSessionEvent());
      }
      yield state.copyWith(selectedTime: timeOfDay, finalNumber: event.finalNumber, endDateTime: endDate);
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
      yield state.copyWith(selectedSessionTypeIndex: event.selectedSessionTypeIndex);
      if (event.selectedSessionTypeIndex == 1) {
        add(GetMissedSessionEvent());
      }
    } else if (event is UpdateCAIndex) {
      yield state.copyWith(selectedCAIconIndex: event.selectedCAIconIndex);
    } else if (event is UpdateJAIndex) {
      yield state.copyWith(selectedJAIconIndex: event.selectedJAIconIndex);
    } else if (event is UpdateSessionNoteEvent) {
      yield state.copyWith(noteText: event.note, cptText: '',);
    } else if (event is UpdateProgText) {
      yield state.copyWith(selectedProgText: event.progText, noteText: '', cptText: '');
    } else if (event is UpdateCptText) {
      yield state.copyWith(cptText: event.cptText, noteText: '',);
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
        selectedShortTermResultListModel2: selectedShortTermResultListModel2,
      );

      selectedShortTermResultListModel.clear();
      selectedShortTermResultListModel2.clear();

      if (state.sessionId != null) {
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
        String sessionDateTime, sessionTime, duration, sessionEndTime, location, location1, sessionType, sessionIDValue;
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
        int selectedSessionTypeIndex;

        TimeOfDay selectedTime;
        int finalNumber;

        checkedValue = completeSessionNotes.confirmed == 1;

        String noteText =  completeSessionNotes.notes ?? '';

        String locationHomeOrSchool = completeSessionNotes.location ?? '';
        List<String> locations = locationHomeOrSchool.split('|').toList();
        location = locations.first;
        location1 = locations[1];
        sessionType =  completeSessionNotes.sessionType ?? 1;
        int index = sessionTypeStrings.indexOf(sessionType);
        if (index != null) {
          selectedSessionTypeIndex = index;
        }


        settingsGroupOrNot = completeSessionNotes.manDateType;

        groupType = settingsGroupOrNot ?? 1;

        duration =  completeSessionNotes.duration.toString();
        finalNumber = completeSessionNotes.duration;
        sessionDateTime = '${completeSessionNotes.sessionDate} ${completeSessionNotes.sessionTime}';
        toPassDate = new DateFormat('MM/dd/yy HH:mm:ss').parse(sessionDateTime);
        sessionTime = DateFormat.jm().format(toPassDate);
        selectedDate = toPassDate;

        endDateTime =  toPassDate.add(Duration(days: 0, hours: 0, minutes: int.parse(duration)));

        sessionEndTime = DateFormat.jm().format(endDateTime);
        if (selectedLtGoalId > -1) {
          List<LongTermGpDropDownModel> models = state.longTermGpDropDownList.where((element) => element.longGoalID == selectedLtGoalId).toList();
          if (models.length > 0) {
            dropDownValue = models[0].longGoalText;
          }
        }
        if (selectedLtGoalId2 > -1) {
          List<LongTermGpDropDownModel> models = state.longTermGpDropDownList.where((element) => element.longGoalID == selectedLtGoalId2).toList();
          if (models.length > 0) {
            dropDownValue2 = models[1].longGoalText;
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
                    if (element.sNESubDetailID == data.categoryTextID) {
                      temp = data;
                    }
                  }
                });
              }
              if (temp != null) {
                if (selectedOutComesIndex > -1) {
                  selectedOutComesIndex2 = state.outComesListItems.indexOf(temp) ?? -1;
                } else {
                  selectedOutComesIndex = state.outComesListItems.indexOf(temp) ?? -1;
                }
              }
            }
          }
        }

        missedSession = completeSessionNotes.singleMakeupSessionNote;

        yield state.copyWith(
          isLoading: false,
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
          selectedSessionTypeIndex: selectedSessionTypeIndex,
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
          missedSessions: missedSession,
          isLock: false,
          mCalId: completeSessionNotes.mCalId,
        );
      }

    } catch (error) {
      print(error);
      yield SessionNoteScreenStateFailure(error: error.toString());
    }
  }


  Stream<SessionNoteScreenState> saveSessionNote(String noteText) async* {
    yield state.copyWith(isLoading: true, noteText: noteText);
    var selectedDate1 = new DateFormat('MM/dd/yy');
    var selectedDate2 = new DateFormat('hh:mm a');

    String dateFinal =  selectedDate1.format(state.selectedDate);

    String sessionTime = selectedDate2.format(state.selectedDate);
    String sessionDateTime = dateFinal;

    String locationHomeOrSchool = '${state.location}|${state.location1}';


    String url =  state.sessionId != null ? baseURL + 'SessionNote/${state.sessionId}/CompleteSessionNote': baseURL + 'SessionNote/0/CompleteSessionNote';

    List<Goals> goals = List();
    List<ShortGoalIDs> shortTerms = List();
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerms.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    List<ShortGoalIDs> shortTerms2 = List();
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

    List<Activities> activities = List();
    state.activitiesListItems.forEach((key, alist) {
      for(int j = 1; j < alist.length; j++) {
        if (alist[j].checkVal) {
          activities.add(Activities(activityDetailID: alist[j].id, categoryDetailID: alist[0].id));
        }
      }
    });
    String progText = '';
    String cptText = '';
    if (state.selectedSessionTypeIndex == 5) {
      progText = state.selectedProgText;
      cptText = state.cptText;
    }
    int mCalId = 0;
    if (state.selectedSessionTypeIndex == 1) {
      mCalId = state.mCalId;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String providerid = prefs.getString('providerid');
    // String gNote = '';
    // if (state.selectedSessionTypeIndex > 3) {
    //   gNote = noteText;
    // } else {
    //   if (state.sessionId == null) {
    //     gNote = generateNoteText() + '\n' + noteText;
    //   } else {
    //     gNote = noteText;
    //   }
    // }
    AddSessionResponse newPost = new AddSessionResponse(
      providerId: providerid,
      studentID: state.student.studentID.toInt(),
      sessionDate: sessionDateTime,
      sessionTime: sessionTime,
      duration: state.finalNumber,
      group: state.groupType,
      manDateType: state.groupType,
      location: locationHomeOrSchool,
      sessionType: sessionTypeStrings[state.selectedSessionTypeIndex],
      notes: noteText,
      confirmed: 0,
      goals: goals,
      activities: activities,
      sessionID: state.sessionId ?? 0,
      progText: progText,
      cptText: cptText,
      sessionNoteExtrasList: sessionNoteExtrasList,
      xid: state.student.xid,
      mCalId: mCalId,
    );
    try {
      AddSessionResponse responseAddSession = await addSessionNoteApi.addSessionDetails(url, body: newPost.toJson());
      yield state.copyWith(isLoading: false);
      yield SessionNoteScreenStateSuccess(selectedDate: state.selectedDate, finalNumber: state.finalNumber);
    } catch (error) {
      print(error.toString());
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SessionNoteScreenState> deleteSession(int id) async* {
    try {
      yield state.copyWith(isLoading: true);
      dynamic response = await deleteSessionApi.deleteSession(id);
      yield state.copyWith(isLoading: false);
      yield SessionNoteScreenStateSuccess();
    } catch (error) {
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SessionNoteScreenState> getMissedSessions(String date, String time, int duration, int studentId) async* {
    try {
      yield state.copyWith(isLoading: true);
      List<MissedSessionModel> response = await completeSessionApi.getMissedSessions(date, time, duration, studentId);
      yield state.copyWith(missedSessions: response, isLoading: false, mCalId: 0);
    } catch (error) {
      yield state.copyWith(isLoading: false);
    }
  }

  String generateNoteText() {
    if (state.selectedLtGoalId < 0) {
      return '';
    }
    String student = state.student.name;
    String noteText = 'IEP goals targeted in this session include:\n';
    String longTerm1 = state.dropDownValue + ' ';
    String shortTerm1 = '';
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerm1 += model.selectedShortgoaltext + '\n';
      }
    }
    String outcome1 = 'Outcome was ';
    if (state.selectedOutComesIndex > -1) {
      outcome1 += state.outComesListItems[state.selectedOutComesIndex].categoryTextDetail.replaceAll('student', student) + '.\n';
    }

    String longTerm2 = '';
    String shortTerm2 = '';
    String outcome2 = '';
    String goal2 = '';

    if (state.selectedLtGoalId2 > -1) {
      if (state.dropDownValue2 != null) {
        longTerm2 = state.dropDownValue2;
        for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel2) {
          if (model.checkVal) {
            shortTerm2 += model.selectedShortgoaltext + '\n';
          }
        }
        outcome2 = 'Outcome was ';
        if (state.selectedOutComesIndex2 > -1) {
          outcome2 += state.outComesListItems[state.selectedOutComesIndex2].categoryTextDetail.replaceAll('student', student) + '.\n';
        }
      }
      if (longTerm1 != '' && shortTerm2 != '' && outcome2 != '') {
        goal2 = longTerm2 + '\n' + shortTerm2 + '\n' + outcome2 + '\n';
      }
    }

    String activities = student + ' participated in these activities and the session consisted of the following: \n';
    bool addCRLF = false;
    bool addAnd = false;
    String separator = '';
    String prevCategory = '';

    state.activitiesListItems.forEach((key, alist) {
      String prefix = '';
      switch (alist[0].title) {
        case 'Free Play/Center':
          prefix = 'Including';
          break;
        case 'Art':
          prefix = 'Including';
          break;
        case 'Circle Time':
          prefix = 'Addressing';
          break;
        case 'Lesson Time':
          prefix = 'Addressing';
          break;
        case 'Mealtime/Snack time':
          prefix = 'Addressing';
          break;
        case 'Transition':
          prefix = 'During';
          break;
        case 'Gross Motor':
          prefix = 'Participating in';
          break;
        case 'Small Group Activity':
          prefix = 'Targeting';
          break;
        case 'Trip/Special Events':
          prefix = 'Trip';
          break;
        default:
          break;
      }
      activities += alist[0].title + ' - ' + prefix + ' ';
      int sameCount = 0;
      if (prevCategory != alist[0].title && prevCategory != '') {
        addCRLF = true;
        addAnd = true;
      } else {
        separator = ', ';
      }
      for(int j = 1; j < alist.length; j++) {
        if (alist[j].checkVal) {
          sameCount += 1;
          if (sameCount > 1 && addAnd) {
            separator = ' and ';
          } else if (sameCount > 1 && addAnd == false) {
            separator = ', ';
          } else {
            separator = '';
          }
          activities += separator + alist[j].title;
          if (addCRLF) {
            activities += '\n';
          }
        }
      }
    });

    String spString = '';
    state.sPcheckListItems.forEach((element) {
      if (element.checkVal) {
        if (spString == '') {
          spString += element.title;
        } else {
          spString += 'and ' + element.title;
        }
      }
    });
    if (spString != '') {
      spString = student + ' ' + spString + '.';
    }
    String siString = '';
    state.sIcheckListItems.forEach((element) {
      if (element.checkVal) {
        if (siString == '') {
          siString += element.title;
        } else {
          siString += 'and ' + element.title;
        }
      }
    });
    if (siString != '') {
      siString = 'These Seit interventions were used to prompt goal oriented learning using ' + spString + '.';
    }

    String caString = '';
    if (state.selectedCAIconIndex > -1) {
      caString = student + ' ' + state.cAcheckListItems[state.selectedCAIconIndex].categoryTextDetail;
    }

    String jaString = '';
    if (state.selectedJAIconIndex > -1) {
      jaString = student + ' ' + state.jAcheckListItems[state.selectedJAIconIndex].categoryTextDetail;
    }

    noteText += longTerm1 + '\n' + shortTerm1 + '\n' + outcome1 + '\n' + goal2 + activities + '\n' + spString + siString + caString + jaString;

    print(noteText);
    return noteText;
  }
}