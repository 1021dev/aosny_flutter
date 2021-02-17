class ProgressAmountModel {
  String student;
  num osis;
  num required;
  num regCompleted;
  String missed;
  num reqNonDir;
  num actNonDir;
  String discrep1;
  num direct;
  num reqNonDir1;
  num actNonDur;
  num discrep;


  ProgressAmountModel(
      this.student,
      this.osis,
      this.required,
      this.regCompleted,
      this.missed,
      this.reqNonDir1,
      this.actNonDir,
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
    regCompleted = json['reg_completed'];
    missed = json['missed'];
    reqNonDir1 = json['req_nondir1'];
    actNonDur = json['act_nondur'];
    discrep1 = json['discrep1'];
    direct = json['direct'];
    reqNonDir = json['req_NonDir'];
    actNonDir = json['act_NonDir'];
    discrep = json['discrep'];
  }
}
