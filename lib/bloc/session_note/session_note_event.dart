import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SessionNoteScreenEvent extends Equatable {
  const SessionNoteScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class SessionNoteScreenInitEvent extends SessionNoteScreenEvent {
  final int studentId;
  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final String sessionId;

  SessionNoteScreenInitEvent({
    this.studentId,
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionNotes,
    this.sessionId,
  });
}

@immutable
class GetHistoryEvent extends SessionNoteScreenEvent {
  final String startDate;
  final String endDate;

  GetHistoryEvent({this.startDate, this.endDate});
}

@immutable
class GetProgressEvent extends SessionNoteScreenEvent {
  final String startDate;
  final String endDate;

  GetProgressEvent({this.startDate, this.endDate});
}

class UpdateSelectedShortTerms extends SessionNoteScreenEvent {
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel;
  UpdateSelectedShortTerms({this.selectedShortTermResultListModel});
}

class UpdateActivityListItem extends SessionNoteScreenEvent {
  final Map<int, List<CheckList>> activitiesListItems;

  UpdateActivityListItem({this.activitiesListItems});
}
class SelectLongTermID extends SessionNoteScreenEvent {
  final int id;

  SelectLongTermID({this.id});
}

class SaveSessionNoteEvent extends SessionNoteScreenEvent {
  final String url;
  final CompleteSessionNotes completeSessionNotes;

  SaveSessionNoteEvent({this.url, this.completeSessionNotes});
}