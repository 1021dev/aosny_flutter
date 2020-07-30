
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
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
  final List<CategoryTextAndID> sPcheckListItems;
  final List<CategoryTextAndID> sIcheckListItems;
  final List<CategoryTextAndID> jAcheckListItems;
  final List<CategoryTextAndID> cAcheckListItems;
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel;
  final int selectedLtGoalId;

  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final String sessionId;

  SessionNoteScreenState({
    this.isLoading = false,
    this.longTermGpDropDownList = const [],
    this.shortTermGpList = const [],
    this.gPcheckListItems = const [],
    this.activitiesListItems = const {},
    this.outComesListItems = const [],
    this.sPcheckListItems = const [],
    this.sIcheckListItems = const [],
    this.jAcheckListItems = const [],
    this.cAcheckListItems = const [],
    this.selectedShortTermResultListModel = const [],
    this.selectedLtGoalId = 0,

    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionNotes,
    this.sessionId,
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
    selectedShortTermResultListModel,
    selectedLtGoalId,
    student,
    selectedStudentName,
    eventType,
    noteText,
    sessionNotes,
    sessionId,
  ];

  SessionNoteScreenState copyWith({
    bool isLoading,
    List<LongTermGpDropDownModel> longTermGpDropDownList,
    List<ShortTermGpModel> shortTermGpList,
    List<CheckList> gPcheckListItems,
    Map<int, List<CheckList>> activitiesListItems,
    List<CategoryTextAndID> outComesListItems,
    List<CategoryTextAndID> sPcheckListItems,
    List<CategoryTextAndID> sIcheckListItems,
    List<CategoryTextAndID> jAcheckListItems,
    List<CategoryTextAndID> cAcheckListItems,
    List<SelectedShortTermResultListModel> selectedShortTermResultListModel,
    int selectedLtGoalId,
    StudentsDetailsModel student,
    String selectedStudentName,
    String eventType,
    String noteText,
    CompleteSessionNotes sessionNotes,
    String sessionId,
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
      jAcheckListItems: jAcheckListItems ?? this.jAcheckListItems,
      cAcheckListItems: cAcheckListItems ?? this.cAcheckListItems,
      selectedShortTermResultListModel: selectedShortTermResultListModel ?? this.selectedShortTermResultListModel,
      selectedLtGoalId: selectedLtGoalId ?? this.selectedLtGoalId,
      student: student ?? this.student,
      selectedStudentName: selectedStudentName ?? this.selectedStudentName,
      eventType: eventType ?? this.eventType,
      noteText: noteText ?? this.noteText,
      sessionNotes: sessionNotes ?? this.sessionNotes,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class SessionNoteScreenStateSuccess extends SessionNoteScreenState {}

class SessionNoteScreenStateFailure extends SessionNoteScreenState {
  final String error;

  SessionNoteScreenStateFailure({@required this.error}) : super();

  @override
  String toString() => 'SessionNoteScreenStateFailure { error: $error }';
}

