
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/missed_session_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SessionNoteScreenState extends Equatable {
  final bool isLoading;
  final List<LongTermGpDropDownModel> longTermGpDropDownList;
  final List<ShortTermGpModel> shortTermGpList;
  final List<CheckList> gPcheckListItems;
  final Map<int, List<CheckList>> activitiesListItems;
  final List<CategoryTextAndID> outComesListItems;
  final List<CategoryTextAndID> spListItems;
  final List<CheckList> sPcheckListItems;
  final List<CategoryTextAndID> siListItems;
  final List<CheckList> sIcheckListItems;
  final List<CategoryTextAndID> jAcheckListItems;
  final List<CategoryTextAndID> cAcheckListItems;
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel;
  final int selectedLtGoalId;
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel2;
  final int selectedLtGoalId2;

  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final int sessionId;

  final int settingsGroupOrNot;
  final String sessionDateTime, sessionTime, duration, sessionEndTime, location1, sessionType, sessionIDValue;
  final String location;
  final int confirmedVal;

  final bool settingPersonSelectedbutton;
  final bool settingGroupSelectedButton;
  final String dropDownValue;
  final String dropDownValue2;
  final bool checkedValue;
  final int groupType;
  final DateTime selectedDate;
  final DateTime toPassDate, endDateTime;
  final String showDate;
  final bool isSelectecDate;
  final bool colorGPMadeProgress;
  final bool colorGPpartialProgress;
  final bool colorGPNoProgress;

  final bool goalsAndProgress;
  final bool isActivities;
  final bool socialPragmaics;
  final bool seitIntervention;
  final bool competedActivites;
  final bool jointAttentionEyeContact;

  final int selectedSPIndex;
  final int selectedSIIndex;
  final int selectedOutComesIndex;
  final int selectedOutComesIndex2;
  final int selectedCAIconIndex;
  final int selectedJAIconIndex;
  final int selectedSessionTypeIndex;

  final TimeOfDay selectedTime;
  final int finalNumber;

  final String selectedProgText;
  final String cptText;

  final List<MissedSessionModel> missedSession;
  final int mCalId;
  final bool isLock;

  SessionNoteScreenState( {
    this.isLoading = false,
    this.longTermGpDropDownList = const [],
    this.shortTermGpList = const [],
    this.gPcheckListItems = const [],
    this.activitiesListItems = const {},
    this.outComesListItems = const [],
    this.sPcheckListItems = const [],
    this.siListItems = const [],
    this.spListItems = const [],
    this.sIcheckListItems = const [],
    this.jAcheckListItems = const [],
    this.cAcheckListItems = const [],
    this.selectedShortTermResultListModel = const [],
    this.selectedLtGoalId = 0,
    this.selectedShortTermResultListModel2 = const [],
    this.selectedLtGoalId2 = -1,
    this.selectedOutComesIndex2 = -1,
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionNotes,
    this.sessionId,

    this.settingsGroupOrNot = 0,
    this.sessionDateTime,
    this.sessionTime,
    this.duration,
    this.sessionEndTime,
    this.location = 'School',
    this.location1,
    this.sessionType,
    this.sessionIDValue,
    this.confirmedVal,

    this.settingPersonSelectedbutton = true,
    this.settingGroupSelectedButton = false,
    this.dropDownValue,
    this.dropDownValue2,
    this.checkedValue = false,
    this.groupType = 1,
    this.selectedDate,
    this.toPassDate,
    this.endDateTime,
    this.showDate,
    this.isSelectecDate = false,
    this.colorGPMadeProgress = true,
    this.colorGPpartialProgress = false,
    this.colorGPNoProgress = false,

    this. goalsAndProgress = false,
    this. isActivities = false,
    this. socialPragmaics = false,
    this. seitIntervention = false,
    this. competedActivites = false,
    this. jointAttentionEyeContact = false,

    this. selectedSPIndex = -1,
    this. selectedSIIndex = -1,
    this. selectedOutComesIndex = -1,
    this. selectedCAIconIndex = -1,
    this. selectedJAIconIndex = -1,
    this. selectedSessionTypeIndex = 0,

    this.selectedTime,
    this.finalNumber= 30,

    this.selectedProgText,
    this.cptText,
    this.missedSession = const [],
    this.mCalId,
    this.isLock = false,
  });

  @override
  List<Object> get props => [
    isLoading,
    longTermGpDropDownList,
    shortTermGpList,
    gPcheckListItems,
    activitiesListItems,
    outComesListItems,
    sPcheckListItems,
    sIcheckListItems,
    jAcheckListItems,
    cAcheckListItems,
    siListItems,
    spListItems,
    selectedShortTermResultListModel,
    selectedLtGoalId,
    selectedShortTermResultListModel2,
    selectedLtGoalId2,
    selectedOutComesIndex2,
    student,
    selectedStudentName,
    eventType,
    noteText,
    sessionNotes,
    sessionId,

    settingsGroupOrNot,
    sessionDateTime,
    sessionTime,
    duration,
    sessionEndTime,
    location,
    location1,
    sessionType,
    sessionIDValue,
    confirmedVal,

    settingPersonSelectedbutton,
    settingGroupSelectedButton,
    dropDownValue,
    dropDownValue2,
    checkedValue,
    groupType,
    selectedDate,
    toPassDate,
    endDateTime,
    showDate,
    isSelectecDate,
    colorGPMadeProgress,
    colorGPpartialProgress,
    colorGPNoProgress,

    goalsAndProgress,
    isActivities,
    socialPragmaics,
    seitIntervention,
    competedActivites,
    jointAttentionEyeContact,

    selectedSPIndex,
    selectedSIIndex,
    selectedOutComesIndex,
    selectedCAIconIndex,
    selectedJAIconIndex,
    selectedSessionTypeIndex,

    selectedTime ,
    finalNumber,

    selectedProgText,
    cptText,
    missedSession,
    mCalId,
    isLock,
  ];

  SessionNoteScreenState copyWith({
    bool isLoading,
    List<LongTermGpDropDownModel> longTermGpDropDownList,
    List<ShortTermGpModel> shortTermGpList,
    List<CheckList> gPcheckListItems,
    Map<int, List<CheckList>> activitiesListItems,
    List<CategoryTextAndID> outComesListItems,
    List<CheckList> sPcheckListItems,
    List<CheckList> sIcheckListItems,
    List<CategoryTextAndID> spListItems,
    List<CategoryTextAndID> siListItems,
    List<CategoryTextAndID> jAcheckListItems,
    List<CategoryTextAndID> cAcheckListItems,
    List<SelectedShortTermResultListModel> selectedShortTermResultListModel,
    int selectedLtGoalId,
    List<SelectedShortTermResultListModel> selectedShortTermResultListModel2,
    int selectedLtGoalId2,
    StudentsDetailsModel student,
    String selectedStudentName,
    String eventType,
    String noteText,
    CompleteSessionNotes sessionNotes,
    int sessionId,
    int settingsGroupOrNot,
    String sessionDateTime, sessionTime, duration, sessionEndTime, location, location1, sessionType, sessionIDValue,
    int confirmedVal,
    bool settingPersonSelectedbutton,
    bool settingGroupSelectedButton,
    String dropDownValue,
    String dropDownValue2,
    bool checkedValue,
    int groupType,
    DateTime selectedDate,
    DateTime toPassDate,endDateTime,
    String showDate,
    bool isSelectecDate,
    bool colorGPMadeProgress,
    bool colorGPpartialProgress,
    bool colorGPNoProgress,

    bool goalsAndProgress,
    bool isActivities,
    bool socialPragmaics,
    bool seitIntervention,
    bool competedActivites,
    bool jointAttentionEyeContact,

    int selectedSPIndex,
    int selectedSIIndex,
    int selectedOutComesIndex,
    int selectedOutComesIndex2,
    int selectedCAIconIndex,
    int selectedJAIconIndex,
    int selectedSessionTypeIndex,

    TimeOfDay selectedTime,
    int finalNumber,
    String selectedProgText,
    String cptText,
    List<MissedSessionModel> missedSessions,
    int mCalId,
    bool isLock,
  }) {
    return SessionNoteScreenState(
      isLoading: isLoading ?? this.isLoading,
      longTermGpDropDownList: longTermGpDropDownList ?? this.longTermGpDropDownList,
      shortTermGpList: shortTermGpList ?? this.shortTermGpList,
      gPcheckListItems: gPcheckListItems ?? this.gPcheckListItems,
      activitiesListItems: activitiesListItems ?? this.activitiesListItems,
      outComesListItems: outComesListItems ?? this.outComesListItems,
      sPcheckListItems: sPcheckListItems ?? this.sPcheckListItems,
      sIcheckListItems: sIcheckListItems ?? this.sIcheckListItems,
      siListItems: siListItems ?? this.siListItems,
      spListItems: spListItems ?? this.spListItems,
      jAcheckListItems: jAcheckListItems ?? this.jAcheckListItems,
      cAcheckListItems: cAcheckListItems ?? this.cAcheckListItems,
      selectedShortTermResultListModel: selectedShortTermResultListModel ?? this.selectedShortTermResultListModel,
      selectedLtGoalId: selectedLtGoalId ?? this.selectedLtGoalId,
      selectedShortTermResultListModel2: selectedShortTermResultListModel2 ?? this.selectedShortTermResultListModel2,
      selectedLtGoalId2: selectedLtGoalId2 ?? this.selectedLtGoalId2,
      student: student ?? this.student,
      selectedStudentName: selectedStudentName ?? this.selectedStudentName,
      eventType: eventType ?? this.eventType,
      noteText: noteText ?? this.noteText,
      sessionNotes: sessionNotes ?? this.sessionNotes,
      sessionId: sessionId ?? this.sessionId,

      checkedValue: checkedValue ?? this.checkedValue,
      colorGPMadeProgress: colorGPMadeProgress ?? this.colorGPMadeProgress,
      colorGPNoProgress: colorGPNoProgress ?? this.colorGPNoProgress,
      colorGPpartialProgress: colorGPpartialProgress ?? this.colorGPpartialProgress,
      competedActivites: competedActivites ?? this.competedActivites,
      confirmedVal: confirmedVal ?? this.confirmedVal,
      dropDownValue: dropDownValue ?? this.dropDownValue,
      dropDownValue2: dropDownValue2 ?? this.dropDownValue2,
      duration: duration ?? this.duration,
      endDateTime: endDateTime ?? this.endDateTime,
      finalNumber: finalNumber ?? this.finalNumber,
      goalsAndProgress: goalsAndProgress ?? this.goalsAndProgress,
      groupType: groupType ?? this.groupType,
      isActivities: isActivities ?? this.isActivities,
      isSelectecDate: isSelectecDate ?? this.isSelectecDate,
      jointAttentionEyeContact: jointAttentionEyeContact ?? this.jointAttentionEyeContact,
      location: location ?? this.location,
      location1: location1 ?? this.location1,
      seitIntervention: seitIntervention ?? this.seitIntervention,
      selectedCAIconIndex: selectedCAIconIndex ?? this.selectedCAIconIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedJAIconIndex: selectedJAIconIndex ?? this.selectedJAIconIndex,
      selectedOutComesIndex: selectedOutComesIndex ?? this.selectedOutComesIndex,
      selectedOutComesIndex2: selectedOutComesIndex2 ?? this.selectedOutComesIndex2,
      selectedSessionTypeIndex: selectedSessionTypeIndex ?? this.selectedSessionTypeIndex,
      selectedSIIndex: selectedSIIndex ?? this.selectedSIIndex,
      selectedSPIndex: selectedSPIndex ?? this.selectedSPIndex,
      selectedTime: selectedTime ?? this.selectedTime,
      sessionDateTime: sessionDateTime ?? this.sessionDateTime,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
      sessionIDValue: sessionIDValue ?? this.sessionIDValue,
      sessionTime: sessionTime ?? this.sessionTime,
      sessionType: sessionType ?? this.sessionType,
      settingGroupSelectedButton: settingGroupSelectedButton ?? this.settingGroupSelectedButton,
      settingPersonSelectedbutton: settingPersonSelectedbutton ?? this.settingPersonSelectedbutton,
      settingsGroupOrNot: settingsGroupOrNot ?? this.settingsGroupOrNot,
      showDate: showDate ?? this.showDate,
      socialPragmaics: socialPragmaics ?? this.socialPragmaics,
      toPassDate: toPassDate ?? this.toPassDate,
      selectedProgText: selectedProgText ?? this.selectedProgText,
      cptText: cptText ?? this.cptText,
      missedSession: missedSessions ?? this.missedSession,
      mCalId: mCalId ?? this.mCalId,
      isLock: isLock ?? this.isLock,
    );
  }
}

class SessionNoteScreenStateSuccess extends SessionNoteScreenState {
  final DateTime selectedDate;
  final int finalNumber;
  SessionNoteScreenStateSuccess({this.selectedDate, this.finalNumber});
}

class SessionNoteScreenStateFailure extends SessionNoteScreenState {
  final String error;
  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final int sessionId;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  SessionNoteScreenStateFailure({
    @required this.error,
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionId,
    this.sessionNotes,
    this.selectedDate,
    this.selectedTime,
  }) : super();

  @override
  String toString() => 'SessionNoteScreenStateFailure { error: $error }';
}

