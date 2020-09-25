class MissedSessionModel {
  num id;
  String sessionDate;
  String sessionTime;
  num duration;
  String sessionType;

  MissedSessionModel({
    this.id,
    this.sessionDate,
    this.sessionTime,
    this.duration,
    this.sessionType,
  });

  MissedSessionModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    sessionDate = json['SessionDate'];
    sessionTime = json['SessionTime'];
    duration = json['Duration'];
    sessionType = json['SessionType'];
  }
}