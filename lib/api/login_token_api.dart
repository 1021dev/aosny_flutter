import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/login_response.dart';
import 'package:http/http.dart' as http;
 
 class LoginApi{


 int statuscode;

Future<LoginResponse> loginApiCall(String url, {Map body}) async {
  
    print(url);
    print(body);

    return http
        .post(url, body: jsonEncode(body), headers:  {HttpHeaders.contentTypeHeader: "application/json"})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
       print("CODE::::");
      print(statusCode);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("data::Login");
      print(response.body);

      //GlobalCall.token = response.body;

      //print("GlobalCall.token");
      //print(GlobalCall.token);

      return LoginResponse.fromJson(json.decode(response.body));
    });
  }
 }