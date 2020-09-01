import 'package:aosny_services/models/category_list.dart';
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

class UpdateSelectedShortTerms extends SessionNoteScreenEvent {
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel;
  UpdateSelectedShortTerms({this.selectedShortTermResultListModel});
}

class UpdateActivityListItem extends SessionNoteScreenEvent {
  final Map<int, List<CheckList>> activitiesListItems;

  UpdateActivityListItem({this.activitiesListItems});
}
class UpdateSocialPragmatics extends SessionNoteScreenEvent {
  final List<CategoryTextAndID> sPcheckListItems;

  UpdateSocialPragmatics({this.sPcheckListItems = const []});
}

class UpdateSEITIntervenion extends SessionNoteScreenEvent {
  final List<CategoryTextAndID> sIcheckListItems;

  UpdateSEITIntervenion({this.sIcheckListItems = const []});
}

class UpdateCompleteActivity extends SessionNoteScreenEvent {
  final List<CategoryTextAndID> cAcheckListItems;

  UpdateCompleteActivity({this.cAcheckListItems = const []});
}

class UpdateJointAttention extends SessionNoteScreenEvent {
  final List<CategoryTextAndID> jAcheckListItems;

  UpdateJointAttention({this.jAcheckListItems = const []});
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

class UpdateSelectedDate extends SessionNoteScreenEvent {
  final DateTime selectedDate;
  UpdateSelectedDate({this.selectedDate});
}

class UpdateSelectedTime extends SessionNoteScreenEvent {
  final TimeOfDay selectedTime;
  UpdateSelectedTime({this.selectedTime});
}

class UpdateFinalNumber extends SessionNoteScreenEvent {
  final int finalNumber;
  UpdateFinalNumber({this.finalNumber});
}

class UpdateHomeBuilding extends SessionNoteScreenEvent {
  final bool isHome;
  UpdateHomeBuilding({this.isHome});
}

class UpdateSchoolGroup extends SessionNoteScreenEvent {
  final int groupType;
  UpdateSchoolGroup({this.groupType});
}

class UpdateDropdownValue extends SessionNoteScreenEvent {
  final String longGoalText;
  UpdateDropdownValue({this.longGoalText});
}

class UpdateCheckedValue extends SessionNoteScreenEvent {
  final bool checkedValue;
  UpdateCheckedValue({this.checkedValue});
}

class UpdateSPIndex extends SessionNoteScreenEvent {
  final int selectedSPIndex;
  UpdateSPIndex({this.selectedSPIndex});
}

class UpdateSIIndex extends SessionNoteScreenEvent {
  final int selectedSIIndex;
  UpdateSIIndex({this.selectedSIIndex});
}

class UpdateOutComeIndex extends SessionNoteScreenEvent {
  final int selectedOutComesIndex;
  UpdateOutComeIndex({this.selectedOutComesIndex});
}

class UpdateSessionType extends SessionNoteScreenEvent {
  final int selectedSessionTypeIndex;
  UpdateSessionType({this.selectedSessionTypeIndex});
}

class UpdateCAIndex extends SessionNoteScreenEvent {
  final int selectedCAIconIndex;
  UpdateCAIndex({this.selectedCAIconIndex});
}

class UpdateJAIndex extends SessionNoteScreenEvent {
  final int selectedJAIconIndex;
  UpdateJAIndex({this.selectedJAIconIndex});
}

class SelectGoalSection extends SessionNoteScreenEvent {
  final isSelect;
  SelectGoalSection({this.isSelect});
}

class SelectActivitySection extends SessionNoteScreenEvent {
  final isSelect;
  SelectActivitySection({this.isSelect});
}

class SelectSISection extends SessionNoteScreenEvent {
  final isSelect;
  SelectSISection({this.isSelect});
}

class SelectSPSection extends SessionNoteScreenEvent {
  final isSelect;
  SelectSPSection({this.isSelect});
}

class SelectCASection extends SessionNoteScreenEvent {
  final isSelect;
  SelectCASection({this.isSelect});
}

class SelectJASection extends SessionNoteScreenEvent {
  final isSelect;
  SelectJASection({this.isSelect});
}
