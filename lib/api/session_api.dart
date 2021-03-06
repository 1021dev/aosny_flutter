import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class SessionApi{
  
  Future<List<LongTermGpDropDownModel>> getLongTermGpDropDownList(int studentId) async {

   //String url =  "http://aosapi.pdgcorp.com/api/Student/246689970/ltgoals";
   String url =  baseURL + "Student/$studentId/ltgoals";
    print(url);
    List<LongTermGpDropDownModel> result;

    //var token = GlobalCall.token;
     
     SharedPreferences prefs = await SharedPreferences.getInstance();
  
    String token = prefs.getString('token');

    return http.get(url,
     headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}
       ).then((http.Response response) {
      int statusCode = response.statusCode;
      
      print("Code::getLongTermGpDropDownList");
      print(statusCode);

      var data = json.decode(response.body);
      print(" DATA:$data");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statusCode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      result = data.map<LongTermGpDropDownModel>(
              (json) => LongTermGpDropDownModel.fromJson(json))
          .toList();

      print(" LongTermGpDropDownModel result List Size: ${result.length}");
      return result;
    });
  }

  Future<List<ShortTermGpModel>> getShortTermGpList(int studentId) async {

  //var token = GlobalCall.token;


   
     SharedPreferences prefs = await SharedPreferences.getInstance();
  
     String token = prefs.getString('token');

   //String url = "http://aosapi.pdgcorp.com/api/Student/246689970/stgoals";
   String url = baseURL + "Student/$studentId/stgoals";

    List<ShortTermGpModel> result;

    return http.get(url,headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}).then((http.Response response) {
      int statusCode = response.statusCode;
      
      print("Code::getShortTermGpList");
      print(statusCode);

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("getShortTermGp LIST:$data");

      result = data.map<ShortTermGpModel>(
              (json) => ShortTermGpModel.fromJson(json))
          .toList();

      print(" ShortTermGpListViewModel result List Size: ${result.length}");
      return result;
    });
  }


  

}