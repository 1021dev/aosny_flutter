import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddSessionApi {

int statuscode;  //AddSessionNotes
Future<AddSessionResponse> addSessionDetails(String url,{Map body}) async { 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    print("url in Api::"+url);

     
    return http
        .post(url, body: jsonEncode(body), headers:  {HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.authorizationHeader: "Bearer $token"})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
       print("add session notes api CODE::::");
      print(statusCode);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
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