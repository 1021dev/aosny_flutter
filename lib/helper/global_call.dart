import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';

class GlobalCall extends ChangeNotifier{

 static var isHistoryOrProgress = "";

 static var token = "";
 static var email  = "";
 static var sessionID = "";

 static List<StudentsDetailsModel> globaleStudentList = new List();

 static DateTime startDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 86400000 * 7);
 static DateTime endDate = DateTime.now();
 static DateTime proStartDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 86400000 * 7);
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

}