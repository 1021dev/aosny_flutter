class MissedSessionModel {
  num id;
  String sessionDateTime;
  num duration;
  String sessionType;

  MissedSessionModel({
    this.id,
    this.sessionDateTime,
    this.duration,
    this.sessionType,
  });

  MissedSessionModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    sessionDateTime = json['SessionDateTime'];
    duration = json['Duration'];
    sessionType = json['SessionType'];
  }
}