import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/missed_session_model.dart';
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

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("Complete Session Notes:$data");

      return CompleteSessionNotes.fromJson(json.decode(response.body));


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

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("Complete Session Notes:$data");

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