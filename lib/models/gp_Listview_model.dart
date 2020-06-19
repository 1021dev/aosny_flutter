 
class ShortTermGpModel {
  int longGoalID;
  int shortgoalid;
  String shortgoaltext;

  ShortTermGpModel({this.longGoalID, this.shortgoalid, this.shortgoaltext});

  ShortTermGpModel.fromJson(Map<String, dynamic> json) {
    longGoalID = json['LongGoalID'];
    shortgoalid = json['shortgoalid'];
    shortgoaltext = json['shortgoaltext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LongGoalID'] = this.longGoalID;
    data['shortgoalid'] = this.shortgoalid;
    data['shortgoaltext'] = this.shortgoaltext;
    return data;
  }
}