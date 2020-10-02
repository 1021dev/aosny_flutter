import 'missed_session_model.dart';

class CompleteSessionNotes {
  int sessionID;
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
  int manDateType;
  int cptCode;
  int progId;
  String cptText;
  String progText;
  List<SessionNoteExtrasList> sessionNoteExtrasList;
  List<MissedSessionModel> singleMakeupSessionNote;
  num mCalId;

  CompleteSessionNotes({
    this.sessionID,
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
    this.sessionNoteExtrasList,
    this.manDateType,
    this.progId = 0,
    this.cptCode = 0,
    this.cptText,
    this.progText,
    this.singleMakeupSessionNote,
    this.mCalId,
  });

  CompleteSessionNotes.fromJson(Map<String, dynamic> json) {
    sessionID = json['SessionID'];
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
    mCalId = json['mCalId'];
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
    if (json['singleMakeupSessionNote'] != null) {
      singleMakeupSessionNote = new List<MissedSessionModel>();
      json['singleMakeupSessionNote'].forEach((v) {
        singleMakeupSessionNote.add(new MissedSessionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SessionID'] = this.sessionID;
    data['SessionDate'] = this.sessionDate;
    data['SessionTime'] = this.sessionTime;
    data['Duration'] = this.duration;
    data['Group'] = this.group;
    data['Location'] = this.location;
    data['SessionType'] = this.sessionType;
    data['Notes'] = this.notes;
    data['ProgId'] = this.progId;
    data['ProgText'] = this.progText;
    data['CptCode'] = this.cptCode;
    data['CptText'] = this.cptText;
    data['ManDateType'] = this.manDateType;
    data['mCalId'] = this.mCalId;
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

class Goals {
  int longGoalID;
  List<ShortGoalIDs> shortGoalIDs;

  Goals({this.longGoalID, this.shortGoalIDs});

  Goals.fromJson(Map<String, dynamic> json) {
    longGoalID = json['LongGoalID'];
    if (json['ShortGoalIDs'] != null) {
      shortGoalIDs = new List<ShortGoalIDs>();
      json['ShortGoalIDs'].forEach((v) {
        shortGoalIDs.add(new ShortGoalIDs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LongGoalID'] = this.longGoalID;
    if (this.shortGoalIDs != null) {
      data['ShortGoalIDs'] = this.shortGoalIDs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShortGoalIDs {
  int shortGoalID;

  ShortGoalIDs({this.shortGoalID});

  ShortGoalIDs.fromJson(Map<String, dynamic> json) {
    shortGoalID = json['ShortGoalID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShortGoalID'] = this.shortGoalID;
    return data;
  }
}

class Activities {
  int categoryDetailID;
  int activityDetailID;

  Activities({this.categoryDetailID, this.activityDetailID});

  Activities.fromJson(Map<String, dynamic> json) {
    categoryDetailID = json['CategoryDetailID'];
    activityDetailID = json['ActivityDetailID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryDetailID'] = this.categoryDetailID;
    data['ActivityDetailID'] = this.activityDetailID;
    return data;
  }
}

class SessionNoteExtrasList {
  int sNECategoryID;
  int sNECategoryDetailID;
  int sNESubDetailID;

  SessionNoteExtrasList(
      {this.sNECategoryID, this.sNECategoryDetailID, this.sNESubDetailID});

  SessionNoteExtrasList.fromJson(Map<String, dynamic> json) {
    sNECategoryID = json['SNE_CategoryID'];
    sNECategoryDetailID = json['SNE_CategoryDetailID'];
    sNESubDetailID = json['SNE_SubDetailID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SNE_CategoryID'] = this.sNECategoryID;
    data['SNE_CategoryDetailID'] = this.sNECategoryDetailID;
    data['SNE_SubDetailID'] = this.sNESubDetailID;
    return data;
  }
}