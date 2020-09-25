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
  final int sessionId;

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

class UpdateSelectedShortTerms2 extends SessionNoteScreenEvent {
  final List<SelectedShortTermResultListModel> selectedShortTermResultListModel;
  UpdateSelectedShortTerms2({this.selectedShortTermResultListModel});
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

class SelectLongTermID2 extends SessionNoteScreenEvent {
  final int id;

  SelectLongTermID2({this.id});
}

class SaveSessionNoteEvent extends SessionNoteScreenEvent {
  final String noteText;

  SaveSessionNoteEvent({this.noteText});
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

class UpdateLocation extends SessionNoteScreenEvent {
  final String location;
  UpdateLocation({this.location});
}

class UpdateLocation1 extends SessionNoteScreenEvent {
  final String location1;
  UpdateLocation1({this.location1});
}

class UpdateSchoolGroup extends SessionNoteScreenEvent {
  final int groupType;
  UpdateSchoolGroup({this.groupType});
}

class UpdateDropdownValue extends SessionNoteScreenEvent {
  final String longGoalText;
  UpdateDropdownValue({this.longGoalText});
}

class UpdateDropdownValue2 extends SessionNoteScreenEvent {
  final String longGoalText;
  UpdateDropdownValue2({this.longGoalText});
}

class UpdateCheckedValue extends SessionNoteScreenEvent {
  final bool checkedValue;
  UpdateCheckedValue({this.checkedValue});
}

class UpdateSpCheckValue extends SessionNoteScreenEvent {
  final List<CheckList> list;
  UpdateSpCheckValue({this.list});
}

class UpdateSiCheckValue extends SessionNoteScreenEvent {
  final List<CheckList> list;
  UpdateSiCheckValue({this.list});
}

class UpdateOutComeIndex extends SessionNoteScreenEvent {
  final int selectedOutComesIndex;
  UpdateOutComeIndex({this.selectedOutComesIndex});
}

class UpdateOutComeIndex2 extends SessionNoteScreenEvent {
  final int selectedOutComesIndex;
  UpdateOutComeIndex2({this.selectedOutComesIndex});
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
  final bool isSelect;
  SelectActivitySection({this.isSelect});
}

class SelectSISection extends SessionNoteScreenEvent {
  final bool isSelect;
  SelectSISection({this.isSelect});
}

class SelectSPSection extends SessionNoteScreenEvent {
  final bool isSelect;
  SelectSPSection({this.isSelect});
}

class SelectCASection extends SessionNoteScreenEvent {
  final bool isSelect;
  SelectCASection({this.isSelect});
}

class SelectJASection extends SessionNoteScreenEvent {
  final bool isSelect;
  SelectJASection({this.isSelect});
}

class UpdateSessionNoteEvent extends SessionNoteScreenEvent {
  final String note;
  UpdateSessionNoteEvent({this.note});
}

class UpdateProgText extends SessionNoteScreenEvent {
  final String progText;
  UpdateProgText({this.progText});
}

class UpdateCptText extends SessionNoteScreenEvent {
  final String cptText;
  UpdateCptText({this.cptText});
}

class DeleteSessionEvent extends SessionNoteScreenEvent {
  final int id;
  DeleteSessionEvent({this.id});
}

class GetMissedSessionEvent extends SessionNoteScreenEvent {
  final String date;
  final String time;
  final int duration;
  final int studentId;

  GetMissedSessionEvent({
    this.date,
    this.time,
    this.duration,
    this.studentId,
  });
}