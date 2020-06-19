import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aosny_services/models/complete_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteSessionApi {

int statuscode;
Future<CompleteSessionNotes> getSessionDetails() async { 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = "http://aosapi.pdgcorp.com/api/SessionNote/226628/CompleteSessionNote";  
    

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
}