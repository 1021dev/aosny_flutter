class ProgressAmountModel {
  String student;
  num osis;
  String required;
  String direct1;
  String missed;
  String reqNonDir1;
  String actNonDur1;
  String discrep1;
  num direct;
  num reqNonDir;
  num actNonDur;
  num discrep;

  // "Student": "Isaac, Nosson",
  // "osis": 247036999,
  // "required": "7 Hours",
  // "direct1": "9.00 Hours",
  // "missed": "2.00 Hours",
  // "req_nondir1": "3.60 Hours",
  // "act_nondur1": "2.67 Hours",
  // "discrep1": "0.93 Hours",
  // "direct": 9,
  // "req_nondir": 3.600000,
  // "act_nondur": 160,
  // "discrep": 56.0

  ProgressAmountModel(
      this.student,
      this.osis,
      this.required,
      this.direct1,
      this.missed,
      this.reqNonDir1,
      this.actNonDur1,
      this.discrep1,
      this.direct,
      this.reqNonDir,
      this.actNonDur,
      this.discrep,
      );

  ProgressAmountModel.fromJson(Map<String, dynamic> json) {
    student = json['Student'];
    osis = json['osis'];
    required = json['required'];
    direct1 = json['direct1'];
    missed = json['missed'];
    reqNonDir1 = json['req_nondir1'];
    actNonDur1 = json['act_nondur1'];
    discrep1 = json['discrep1'];
    direct = json['direct'];
    reqNonDir = json['req_nondir'];
    actNonDur = json['act_nondur'];
    discrep = json['discrep'];
  }
}