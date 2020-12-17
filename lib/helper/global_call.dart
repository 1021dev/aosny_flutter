import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/login_response.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalCall extends ChangeNotifier{

 static String terms = 'https://auditoryoralservices.com/app_tos.htm';
 static String privacy = 'https://auditoryoralservices.com/app_privacy.htm';
 static var isHistoryOrProgress = "";

 static var token = "";
 static var email  = "";
 static var singUpEmil  = "";
 static var name  = "";
 static var fullName  = "";
 static var sessionID = "";

 static List<StudentsDetailsModel> globaleStudentList = new List();

 static DateTime startDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 86400000 * 6);
 static DateTime endDate = DateTime.now();
 static DateTime proStartDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 86400000 * 6);
 static DateTime proEndDate = DateTime.now();

 static CategoryList socialPragmatics = new CategoryList();
 static CategoryList SEITIntervention = new CategoryList();
 static CategoryList completedActivity = new CategoryList();
 static CategoryList jointAttention = new CategoryList();
 static CategoryList activities = new CategoryList();
 static CategoryList outcomes = new CategoryList();
 static bool filterDates = true;
 static bool filterStudents = false;
 static String student = '';
 static String sessionType = '';
 static bool filterSessionTypes = false;
 static int providerID = 0;
 static LoginResponse user;

 static bool openDrawer = true;

}

List<String> nonDirectActivities = [
 'Coordination / Collaboration',
 'Attending IEP meetings',
 'Preparation for session',
];
List<String> methodOfContact = [
 'Phone',
 'In Person',
 'Meeting',
 'Email',
 'Notebook',
];
List<String> partyContacted = [
 'Parent',
 'Teacher',
 'Director / Principal',
 'Supervisor',
 'Therapist',
];

List<String> cptCodeId = [
 'Phone',
 'Parent',
 'In Person',
 'Teacher',
 'Meeting',
 'Director / Principal',
 'Email',
 'Supervisor',
 'Notebook',
 'Therapist',
];

List<String> prepTypes = [
 'Secured an appropriate environment for sessions.',
 'Researched strategies, techniques and materials to target IEP goals',
 'Created lesson plan and prepared materials to be used during session to target IEP goals',
 'Documented progress toward attaining IEP Goals',
 'Assessed current skill level and strategies to target IEP goals',
 'Prepared paperwork and documentation for Annual CPSE review',
 'Prepared paperwork and documentation for child\'s `Turning 5` CSE meeting',
];

List<String> locationText = [
 'School',
 'Home',
 'Day Care',
 'Teletherapy',
];
List<String> location1Text = [
 'Class',
 'Ind',
];

Color colorFromStatus(int status) {
 switch (status) {
  case 0:
   return Colors.white;
  case 1:
   return Colors.yellow;
  case 2:
   return Colors.red;
  case 3:
   return Colors.deepPurple;
  case 4:
   return Colors.blue;
  case 5:
   return Colors.green;
  default:
   return Colors.white;
 }
}

String stringFroStatus(int status) {
 switch (status) {
  case 0:
   return 'Uncertified';
  case 1:
   return 'Certified';
  case 2:
   return 'Vouchered';
  case 3:
   return 'Approved';
  case 4:
   return 'Processed';
  case 5:
   return 'Completed';
  default:
   return 'Uncertified';
 }
}