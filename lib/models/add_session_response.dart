class AddSessionResponse {
  int sessionID;
  String sessionDate;
  String sessionTime;
  int duration;
  String group;
  String location;
  String sessionType;
  String notes;
  List<Null> goals;
  List<Null> activities;
  int confirmed;
  List<Null> sessionNoteExtrasList;

  AddSessionResponse(
      {this.sessionID,
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
      this.sessionNoteExtrasList});

  AddSessionResponse.fromJson(Map<String, dynamic> json) {
    sessionID = json['SessionID'];
    sessionDate = json['SessionDate'];
    sessionTime = json['SessionTime'];
    duration = json['Duration'];
    group = json['Group'];
    location = json['Location'];
    sessionType = json['SessionType'];
    notes = json['Notes'];
    if (json['Goals'] != null) {
      goals = new List<Null>();
      json['Goals'].forEach((v) {
        //goals.add(new Null.fromJson(v));
      });
    }
    if (json['Activities'] != null) {
      activities = new List<Null>();
      json['Activities'].forEach((v) {
        //activities.add(new Null.fromJson(v));
      });
    }
    confirmed = json['Confirmed'];
    if (json['SessionNoteExtrasList'] != null) {
      sessionNoteExtrasList = new List<Null>();
      json['SessionNoteExtrasList'].forEach((v) {
        //sessionNoteExtrasList.add(new Null.fromJson(v));
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
    if (this.goals != null) {
      //data['Goals'] = this.goals.map((v) => v.toJson()).toList();
    }
    if (this.activities != null) {
      //data['Activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    data['Confirmed'] = this.confirmed;
    if (this.sessionNoteExtrasList != null) {
     // data['SessionNoteExtrasList'] =
       //   this.sessionNoteExtrasList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}