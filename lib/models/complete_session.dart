class CompleteSessionNotes {
  
  int sessionID;
  String sessionDate;
  String sessionTime;
  int duration;
  String group;
  String location;
  String sessionType;
  String notes;
  List<LongGoals> longGoals;
  List<ShortGoals> shortGoals;
  String outcome;
  List<Activities> activities;
  List socialPragmatics;
  List sEITIntervention;
  Null completedActivity;
  Null jointAttentionEyeContact;
  int confirmed;
  List<SessionNoteExtrasList> sessionNoteExtrasList;

  CompleteSessionNotes(
      {this.sessionID,
      this.sessionDate,
      this.sessionTime,
      this.duration,
      this.group,
      this.location,
      this.sessionType,
      this.notes,
      this.longGoals,
      this.shortGoals,
      this.outcome,
      this.activities,
      this.socialPragmatics,
      this.sEITIntervention,
      this.completedActivity,
      this.jointAttentionEyeContact,
      this.confirmed,
      this.sessionNoteExtrasList});

  CompleteSessionNotes.fromJson(Map<String, dynamic> json) {
    sessionID = json['SessionID'];
    sessionDate = json['SessionDate'];
    sessionTime = json['SessionTime'];
    duration = json['Duration'];
    group = json['Group'];
    location = json['Location'];
    sessionType = json['SessionType'];
    notes = json['Notes'];
    if (json['LongGoals'] != null) {
      longGoals = new List<LongGoals>();
      json['LongGoals'].forEach((v) {
        longGoals.add(new LongGoals.fromJson(v));
      });
    }
    if (json['ShortGoals'] != null) {
      shortGoals = new List<ShortGoals>();
      json['ShortGoals'].forEach((v) {
        shortGoals.add(new ShortGoals.fromJson(v));
      });
    }
    outcome = json['Outcome'];
    if (json['Activities'] != null) {
      activities = new List<Activities>();
      json['Activities'].forEach((v) {
        activities.add(new Activities.fromJson(v));
      });
    }
    if (json['SocialPragmatics'] != null) {
      socialPragmatics = new List<Null>();
      json['SocialPragmatics'].forEach((v) {
        //socialPragmatics.add(new Null.fromJson(v));
      });
    }
    if (json['SEITIntervention'] != null) {
      sEITIntervention = new List<Null>();
      json['SEITIntervention'].forEach((v) {
        //sEITIntervention.add(new Null.fromJson(v));
      });
    }
    completedActivity = json['CompletedActivity'];
    jointAttentionEyeContact = json['JointAttentionEyeContact'];
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
    data['SessionDate'] = this.sessionDate;
    data['SessionTime'] = this.sessionTime;
    data['Duration'] = this.duration;
    data['Group'] = this.group;
    data['Location'] = this.location;
    data['SessionType'] = this.sessionType;
    data['Notes'] = this.notes;
    if (this.longGoals != null) {
      data['LongGoals'] = this.longGoals.map((v) => v.toJson()).toList();
    }
    if (this.shortGoals != null) {
      data['ShortGoals'] = this.shortGoals.map((v) => v.toJson()).toList();
    }
    data['Outcome'] = this.outcome;
    if (this.activities != null) {
      data['Activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    if (this.socialPragmatics != null) {
      data['SocialPragmatics'] =
          this.socialPragmatics.map((v) => v.toJson()).toList();
    }
    if (this.sEITIntervention != null) {
      data['SEITIntervention'] =
          this.sEITIntervention.map((v) => v.toJson()).toList();
    }
    data['CompletedActivity'] = this.completedActivity;
    data['JointAttentionEyeContact'] = this.jointAttentionEyeContact;
    data['Confirmed'] = this.confirmed;
    if (this.sessionNoteExtrasList != null) {
      data['SessionNoteExtrasList'] =
          this.sessionNoteExtrasList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LongGoals {
  int longGoalID;

  LongGoals({this.longGoalID});

  LongGoals.fromJson(Map<String, dynamic> json) {
    longGoalID = json['LongGoalID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LongGoalID'] = this.longGoalID;
    return data;
  }
}

class ShortGoals {
  int shortGoalID;

  ShortGoals({this.shortGoalID});

  ShortGoals.fromJson(Map<String, dynamic> json) {
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