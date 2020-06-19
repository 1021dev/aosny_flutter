class LongTermGpDropDownModel {
  int mandateid;
  int longGoalID;
  String longGoalText;

  LongTermGpDropDownModel({this.mandateid, this.longGoalID, this.longGoalText});

  LongTermGpDropDownModel.fromJson(Map<String, dynamic> json) {
    mandateid = json['mandateid'];
    longGoalID = json['LongGoalID'];
    longGoalText = json['LongGoalText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mandateid'] = this.mandateid;
    data['LongGoalID'] = this.longGoalID;
    data['LongGoalText'] = this.longGoalText;
    return data;
  }
}


