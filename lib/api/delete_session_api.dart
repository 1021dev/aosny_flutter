import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class DeleteSessionApi {

int statuscode;
Future<bool> deleteSession(int id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = baseURL + 'SessionNote/$id/DeleteSessionNote';
    return http
        .delete(url, headers:  {HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.authorizationHeader: "Bearer $token"})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;

      dynamic data = json.decode(response.body);
      print(data);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statusCode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print("data::delete session");
      print(response.body);
      return true;
    });
  }
}