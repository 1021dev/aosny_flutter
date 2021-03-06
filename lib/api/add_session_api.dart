import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddSessionApi {

int statuscode;  //AddSessionNotes
Future<AddSessionResponse> addSessionDetails(String url,{Map body}) async { 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    print("url in Api:: $body");
    print("url in Api::"+url);


    return http
        .post(url, body: jsonEncode(body), headers:  {HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.authorizationHeader: "Bearer $token"})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
       print("add session notes api CODE::::");
      print(statusCode);
      dynamic data = json.decode(response.body);
      print(data);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statusCode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print("data::add session");
      print(response.body);

      //GlobalCall.token = response.body;

      //print("GlobalCall.token");
      //print(GlobalCall.token);
      //return response.body;

      return AddSessionResponse.fromJson(json.decode(response.body));
    });
  }
}