import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:aosny_services/models/login_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 
class LoginApi{
  int statuscode;

  Future<LoginResponse> loginApiCall(String url, {Map body}) async {

    print(url);
    print(body);

    return http
        .post(url, body: jsonEncode(body), headers:  {HttpHeaders.contentTypeHeader: 'application/json'})
        .then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
      print('CODE::::');
      print(statusCode);

      var data = json.decode(response.body);
      print("DATA:$data");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statuscode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print('data::Login');
      print(response.body);

      return LoginResponse.fromJson(data);
    });
  }

  Future<http.Response> postSignature({String base}) async {

    print(base);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userID = preferences.getInt('user_id') ?? 0;
    String providerID = preferences.getString('providerid') ?? '';
    String token = preferences.getString('token');
    Map body = {
      'userID': userID,
      'providerID': providerID,
      'fileExtension': '.png',
      'fileContents': base,
    };

    return http.post(
      'http://aosapi.pdgcorp.com/api/Token/UploadSignature',
      body: jsonEncode(body),
      headers:  {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
      print('CODE::::');
      print(statusCode);
      var data = json.decode(response.body);
      print("DATA:$data");
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statuscode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print('data::Login');
      print(response.body);

      return response;
    });
  }

  Future<http.Response> forgetPassword({String userName}) async {
    Map body = {
      'username': userName,
    };

    return http.post(
      'http://aosapi.pdgcorp.com/api/Provider/0/forgotpassword',
      body: jsonEncode(body),
      headers:  {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
      print('CODE::::');
      print(statusCode);

      var data = json.decode(response.body);
      print("DATA:$data");
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statuscode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print('data::forgot');
      print(response.body);

      return response;
    });
  }

  Future<http.Response> changePassword({String oldPassword, String newPassword}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userID = preferences.getInt('user_id') ?? 0;
    String providerID = preferences.getString('providerid') ?? '';
    String token = preferences.getString('token');

    Map body = {
      'plainOldPassword': oldPassword,
      'plainNewPassword': newPassword,
    };
    String url = 'http://aosapi.pdgcorp.com/api/Provider/$providerID/changepassword';
    print(url);
    print(jsonEncode(body));
    return http.post(
      url,
      body: jsonEncode(body),
      headers:  {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      statuscode = statusCode;
      print('CODE::::');
      print(statusCode);

      var data = json.decode(response.body);
      print("DATA:$data");
      if (statusCode < 200 || statusCode > 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      } else if (statuscode == 400) {
        Fluttertoast.showToast(msg: data['message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
      }
      print('data:: Change Password');
      print(response.body);

      return response;
    });
  }
}