
import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class StudentApi{

  //String url = "http://aosapi.pdgcorp.com/api/Provider/051829096/students";

  //var token = GlobalCall.token;
  

  Future<List<StudentsDetailsModel>> getAllStudentsList() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();


    String token = prefs.getString('token');
    String providerid = prefs.getString('providerid');

    String url = baseURL + "Provider/" + providerid + "/students";
    print(url);


    List<StudentsDetailsModel> result;

    return http.get(url,headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}).then((http.Response response) {
      int statusCode = response.statusCode;
      
      print("Code::");
      print(statusCode);

      var data = json.decode(response.body);
      print(" DATA:$data");

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      }

      result = data.map<StudentsDetailsModel>(
              (json) => StudentsDetailsModel.fromJson(json))
          .toList();
      //print("print(result);");
          
      
      print(" Student result List Size: ${result.length}");
      return result;
    });
  }


}