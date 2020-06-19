class ProgressAmountModel {
  String lname;
  String fname;
  String sname;
  int studentid;
  String service;
  int nDMins;
  int mandatedNDMins;
  int serviceMins;
  int mandatedMins;

  ProgressAmountModel(
      this.lname,
      this.fname,
      this.sname,
      this.studentid,
      this.service,
      this.nDMins,
      this.mandatedNDMins,
      this.serviceMins,
      this.mandatedMins);

  ProgressAmountModel.fromJson(Map<String, dynamic> json) {
    lname = json['lname'];
    fname = json['fname'];
    sname = json['sname'];
    studentid = json['studentid'];
    service = json['service'];
    nDMins = json['NDMins'];
    mandatedNDMins = json['MandatedNDMins'];
    serviceMins = json['ServiceMins'];
    mandatedMins = json['MandatedMins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lname'] = this.lname;
    data['fname'] = this.fname;
    data['sname'] = this.sname;
    data['studentid'] = this.studentid;
    data['service'] = this.service;
    data['NDMins'] = this.nDMins;
    data['MandatedNDMins'] = this.mandatedNDMins;
    data['ServiceMins'] = this.serviceMins;
    data['MandatedMins'] = this.mandatedMins;
    return data;
  }
}