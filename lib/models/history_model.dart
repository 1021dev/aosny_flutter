class HistoryModel {
  int iD;
  String lname;
  String fname;
  String subject;
  String starttime;
  String sname;
  String osis;
  String dob;
  String dist;
  String svc;
  int freq;
  int nmin;
  int grp;
  String mandate;
  String lang;
  String pname;
  String ssno;
  String sdate;
  String stime;
  String etime;
  String agrp;
  double  hr;
  double ahr;
  int xid;
  String xidlist;
  String tstatus;
  String progtext;
  String notes;

  HistoryModel(
      this.iD,
      this.lname,
      this.fname,
      this.subject,
      this.starttime,
      this.sname,
      this.osis,
      this.dob,
      this.dist,
      this.svc,
      this.freq,
      this.nmin,
      this.grp,
      this.mandate,
      this.lang,
      this.pname,
      this.ssno,
      this.sdate,
      this.stime,
      this.etime,
      this.agrp,
      this.hr,
      this.ahr,
      this.xid,
      this.xidlist,
      this.tstatus,
      this.progtext,
      this.notes);

  HistoryModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    lname = json['lname'];
    fname = json['fname'];
    subject = json['subject'];
    starttime = json['starttime'];
    sname = json['sname'];
    osis = json['osis'];
    dob = json['dob'];
    dist = json['dist'];
    svc = json['svc'];
    freq = json['freq'];
    nmin = json['nmin'];
    grp = json['grp'];
    mandate = json['mandate'];
    lang = json['lang'];
    pname = json['pname'];
    ssno = json['ssno'];
    sdate = json['sdate'];
    stime = json['stime'];
    etime = json['etime'];
    agrp = json['agrp'];
    hr = json['hr'].toDouble();
    ahr = json['ahr'].toDouble();
    xid = json['xid'];
    xidlist = json['xidlist'];
    tstatus = json['tstatus'];
    progtext = json['progtext'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['lname'] = this.lname;
    data['fname'] = this.fname;
    data['subject'] = this.subject;
    data['starttime'] = this.starttime;
    data['sname'] = this.sname;
    data['osis'] = this.osis;
    data['dob'] = this.dob;
    data['dist'] = this.dist;
    data['svc'] = this.svc;
    data['freq'] = this.freq;
    data['nmin'] = this.nmin;
    data['grp'] = this.grp;
    data['mandate'] = this.mandate;
    data['lang'] = this.lang;
    data['pname'] = this.pname;
    data['ssno'] = this.ssno;
    data['sdate'] = this.sdate;
    data['stime'] = this.stime;
    data['etime'] = this.etime;
    data['agrp'] = this.agrp;
    data['hr'] = this.hr;
    data['ahr'] = this.ahr;
    data['xid'] = this.xid;
    data['xidlist'] = this.xidlist;
    data['tstatus'] = this.tstatus;
    data['progtext'] = this.progtext;
    data['notes'] = this.notes;
    return data;
  }
}