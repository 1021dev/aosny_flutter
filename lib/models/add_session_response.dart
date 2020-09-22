import 'package:aosny_services/models/complete_session.dart';

class AddSessionResponse {
  int sessionID;
  int studentID;
  String sessionDate;
  String sessionTime;
  int duration;
  num group;
  String location;
  String sessionType;
  String notes;
  List<Goals> goals;
  List<Activities> activities;
  int confirmed;
  List<SessionNoteExtrasList> sessionNoteExtrasList;
  int cptCode;
  int progId;
  String cptText;
  String progText;
  int manDateType;
  String providerId;
  int xid;

  AddSessionResponse(
      {this.sessionID,
        this.studentID,
        this.sessionDate,
        this.sessionTime,
        this.duration,
        this.group,
        this.location,
        this.sessionType,
        this.notes,
        this.goals,
        this.activities,
        this.confirmed,
        this.progId,
        this.cptCode,
        this.cptText,
        this.progText,
        this.manDateType,
        this.sessionNoteExtrasList,
        this.providerId,
        this.xid,
      });

  AddSessionResponse.fromJson(Map<String, dynamic> json) {
    sessionID = json['SessionID'];
    studentID = json['StudentID'];
    sessionDate = json['SessionDate'];
    sessionTime = json['SessionTime'];
    duration = json['Duration'];
    group = json['Group'];
    location = json['Location'];
    sessionType = json['SessionType'];
    notes = json['Notes'];
    cptCode = json['CptCode'];
    cptText = json['CptText'];
    progId = json['ProgId'];
    progText = json['ProgText'];
    manDateType = json['MandateType'];
    providerId = json['ProviderID'];
    xid = json['xid'];
    if (json['Goals'] != null) {
      goals = new List<Goals>();
      json['Goals'].forEach((v) {
        goals.add(new Goals.fromJson(v));
      });
    }
    if (json['Activities'] != null) {
      activities = new List<Activities>();
      json['Activities'].forEach((v) {
        activities.add(new Activities.fromJson(v));
      });
    }
    confirmed = json['Confirmed'];
    if (json['SessionNoteExtrasList'] != null) {
      sessionNoteExtrasList = new List<SessionNoteExtrasList>();
      json['SessionNoteExtrasList'].forEach((v) {
        sessionNoteExtrasList.add(new SessionNoteExtrasList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SessionID'] = this.sessionID;
    data['StudentID'] = this.studentID;
    data['SessionDate'] = this.sessionDate;
    data['SessionTime'] = this.sessionTime;
    data['Duration'] = this.duration ?? 30;
    data['Group'] = this.group ?? 1;
    data['Location'] = this.location;
    data['SessionType'] = this.sessionType;
    data['Notes'] = this.notes ?? '';
    data['ProgId'] = this.progId ?? 0;
    data['ProgText'] = this.progText ?? '';
    data['CptCode'] = this.cptCode ?? -1;
    data['CptText'] = this.cptText ?? '';
    data['ManDateType'] = this.manDateType ?? 1;
    data['ProviderID'] = this.providerId ?? 1;
    data['xid'] = this.xid ?? -1;
    if (this.goals != null) {
      data['Goals'] = this.goals.map((v) => v.toJson()).toList();
    }
    if (this.activities != null) {
      data['Activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    data['Confirmed'] = this.confirmed;
    if (this.sessionNoteExtrasList != null) {
      data['SessionNoteExtrasList'] =
          this.sessionNoteExtrasList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}