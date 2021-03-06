import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/missed_session_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:aosny_services/models/complete_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class CompleteSessionApi {

  int statuscode;
  Future<CompleteSessionNotes> getSessionDetails(String url) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    print("url in Api::"+url);



    return http.get(url,headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}).then((http.Response response) {

      int statusCode = response.statusCode;

      statuscode = statusCode;
      print("CODE::::");
      print(statusCode);

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("Complete Session Notes:$data");

      return CompleteSessionNotes.fromJson(json.decode(response.body));


    });
  }

  Future<TimeList> getTimeList(int studentId, String startDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String providerid = prefs.getString('providerid');

    String url = baseURL + 'Provider/$providerid/timelist?studentid=$studentId&startdate=$startDate';
    print("url in Api::"+url);

    return http.get(url, headers: {HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.authorizationHeader: "Bearer $token"})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
      print("CODE::::");
      print(statusCode);
      dynamic data = json.decode(response.body);
      print(data);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statusCode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print(data);
      TimeList timeList;
      if (data is Map) {
        timeList = TimeList.fromJson(data);
      }
      return timeList;
    });

  }

  Future<List<MissedSessionModel>> getMissedSessions(String date, String time, int duration, num studentId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = baseURL + 'sessionnote/0/MakeupSessionNote';
    print("url in Api::"+url);

    Map body =  {
      'SessionDate': date,
      'SessionTime': time,
      'Duration': duration,
      'StudentID': studentId,
    };

    return http
        .post(url, body: jsonEncode(body), headers:  {HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.authorizationHeader: "Bearer $token"})
        .then((http.Response response) {

      int statusCode = response.statusCode;

      statuscode = statusCode;
      print("CODE::::");
      print(statusCode);

      var data = json.decode(response.body);
      print("Missed Session Notes:$data");
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      }

      List<MissedSessionModel> array = [];
      if (data is List) {
        data.forEach((element) {
          array.add(MissedSessionModel.fromJson(element));
        });
      }
      return array;
    });
  }



}