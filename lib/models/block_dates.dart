class BlockDate {
  String startTime;
  String subject;

  BlockDate({
    this.startTime,
    this.subject,
  });

  BlockDate.fromJson(Map<String, dynamic> json) {
    startTime = json['StartTime'];
    subject = json['Subject'];
  }
}