/*class StudentsDetailsModel {
  int id;
  String lastName;
  String firstName;
  String season;
  String xname;
  String name;
  int studentID;
  String dOB;
  String guardian;
  String guardianPhoneNumber;
  String freq;
  String mhours;
  String schoolName;
  String schoolDBN;
  int xid;
  String startDate;
  String notseen;
  Null progdt;
  Null dprgrpt;
  String mandate;
  String assignmentdate;
  String xtmswk;
  String xdaydur;

  StudentsDetailsModel(
      this.id,
      this.lastName,
      this.firstName,
      this.season,
      this.xname,
      this.name,
      this.studentID,
      this.dOB,
      this.guardian,
      this.guardianPhoneNumber,
      this.freq,
      this.mhours,
      this.schoolName,
      this.schoolDBN,
      this.xid,
      this.startDate,
      this.notseen,
      this.progdt,
      this.dprgrpt,
      this.mandate,
      this.assignmentdate,
      this.xtmswk,
      this.xdaydur);

  StudentsDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastName = json['last Name'];
    firstName = json['First Name'];
    season = json['season'];
    xname = json['xname'];
    name = json['Name'];
    studentID = json['Student ID'];
    dOB = json['DOB'];
    guardian = json['guardian'];
    guardianPhoneNumber = json['Guardian Phone Number'];
    freq = json['Freq'];
    mhours = json['mhours'];
    schoolName = json['School Name'];
    schoolDBN = json['School DBN'];
    xid = json['xid'];
    startDate = json['StartDate'];
    notseen = json['notseen'];
    progdt = json['progdt'];
    dprgrpt = json['dprgrpt'];
    mandate = json['mandate'];
    assignmentdate = json['assignmentdate'];
    xtmswk = json['xtmswk'];
    xdaydur = json['xdaydur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last Name'] = this.lastName;
    data['First Name'] = this.firstName;
    data['season'] = this.season;
    data['xname'] = this.xname;
    data['Name'] = this.name;
    data['Student ID'] = this.studentID;
    data['DOB'] = this.dOB;
    data['guardian'] = this.guardian;
    data['Guardian Phone Number'] = this.guardianPhoneNumber;
    data['Freq'] = this.freq;
    data['mhours'] = this.mhours;
    data['School Name'] = this.schoolName;
    data['School DBN'] = this.schoolDBN;
    data['xid'] = this.xid;
    data['StartDate'] = this.startDate;
    data['notseen'] = this.notseen;
    data['progdt'] = this.progdt;
    data['dprgrpt'] = this.dprgrpt;
    data['mandate'] = this.mandate;
    data['assignmentdate'] = this.assignmentdate;
    data['xtmswk'] = this.xtmswk;
    data['xdaydur'] = this.xdaydur;
    return data;
  }
}*/
class StudentsDetailsModel {
  int id;
  String lastName;
  String firstName;
  String season;
  String xname;
  String name;
  double studentID;
  String dOB;
  String guardian;
  String guardianPhoneNumber;
  String freq;
  String mhours;
  String schoolName;
  String schoolDBN;
  int xid;
  String startDate;
  String notseen;
  Null progdt;
  Null dprgrpt;
  String mandate;
  String assignmentdate;
  String xtmswk;
  String xdaydur;

  StudentsDetailsModel(
      {this.id,
      this.lastName,
      this.firstName,
      this.season,
      this.xname,
      this.name,
      this.studentID,
      this.dOB,
      this.guardian,
      this.guardianPhoneNumber,
      this.freq,
      this.mhours,
      this.schoolName,
      this.schoolDBN,
      this.xid,
      this.startDate,
      this.notseen,
      this.progdt,
      this.dprgrpt,
      this.mandate,
      this.assignmentdate,
      this.xtmswk,
      this.xdaydur});

  StudentsDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastName = json['last Name'];
    firstName = json['First Name'];
    season = json['season'];
    xname = json['xname'];
    name = json['Name'];
    studentID = json['Student ID'].toDouble();
    dOB = json['DOB'];
    guardian = json['guardian'];
    guardianPhoneNumber = json['Guardian Phone Number'];
    freq = json['Freq'];
    mhours = json['mhours'];
    schoolName = json['School Name'];
    schoolDBN = json['School DBN'];
    xid = json['xid'];
    startDate = json['StartDate'];
    notseen = json['notseen'];
    progdt = json['progdt'];
    dprgrpt = json['dprgrpt'];
    mandate = json['mandate'];
    assignmentdate = json['assignmentdate'];
    xtmswk = json['xtmswk'];
    xdaydur = json['xdaydur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last Name'] = this.lastName;
    data['First Name'] = this.firstName;
    data['season'] = this.season;
    data['xname'] = this.xname;
    data['Name'] = this.name;
    data['Student ID'] = this.studentID;
    data['DOB'] = this.dOB;
    data['guardian'] = this.guardian;
    data['Guardian Phone Number'] = this.guardianPhoneNumber;
    data['Freq'] = this.freq;
    data['mhours'] = this.mhours;
    data['School Name'] = this.schoolName;
    data['School DBN'] = this.schoolDBN;
    data['xid'] = this.xid;
    data['StartDate'] = this.startDate;
    data['notseen'] = this.notseen;
    data['progdt'] = this.progdt;
    data['dprgrpt'] = this.dprgrpt;
    data['mandate'] = this.mandate;
    data['assignmentdate'] = this.assignmentdate;
    data['xtmswk'] = this.xtmswk;
    data['xdaydur'] = this.xdaydur;
    return data;
  }
}
