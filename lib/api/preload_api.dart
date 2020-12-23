import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/block_dates.dart';
import 'package:aosny_services/models/category_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class PreLoadApi{
  List<String> preloadKeys = [
    'SocialPragmatics',
    'Outcomes',
    'SEITIntervention',
    'CompletedActivity',
    'JointAttention',
    'Activities',
    'Outcomes',
  ];
  Future<bool> fetchPreLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';

    if (token == '') {
      return false;
    }

    print('load all');
    await getPreLoadData('all');
    await getBlockOutDates();

    return true;
  }

  Future<bool> getPreLoadData(String type) async {

    String url =  baseURL + "PreLoad/$type";
    bool result = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    if (token == '') {
      return result;
    }
    return http.get(url,
        headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      print(statusCode);

      var data = json.decode(response.body);
      print("DATA:$data");

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      }

      if (data is Map) {
        data.forEach((key, value) {
          switch (key) {
            case "socialPragmatics":
              GlobalCall.socialPragmatics = CategoryList.fromJson(value);
              break;
            case "seitINtervention":
              GlobalCall.SEITIntervention = CategoryList.fromJson(value);
              break;
            case "completedActivity":
              GlobalCall.completedActivity = CategoryList.fromJson(value);
              break;
            case "jointAttention":
              GlobalCall.jointAttention = CategoryList.fromJson(value);
              break;
            case "loadActivities":
              GlobalCall.activities = CategoryList.fromJson(value);
              break;
            case "outComes":
              GlobalCall.outcomes = CategoryList.fromJson(value);
              break;
          }
        });
      }

      return true;
    });
  }

  Future<bool> getBlockOutDates() async {
    String url =  baseURL + "PreLoad/BlockOutDates";
    bool result = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    if (token == '') {
      return result;
    }

    return http.get(url,
        headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      print(statusCode);

      var data = json.decode(response.body);
      print("DATA:$data");

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        Fluttertoast.showToast(msg: data['Message'] ?? 'An internal error has occurred. The administrator has been notified', toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
        throw new Exception(data['Message'] ?? 'An internal error has occurred. The administrator has been notified');
      }

      List<BlockDate> blockDates = [];
      if (data is List) {
        data.forEach((element) {
          blockDates.add(BlockDate.fromJson(element));
        });
      }
      // List<String> blockDates = [];
      // if (data is List) {
      //   data.forEach((element) {
      //     BlockDate blockDate = BlockDate.fromJson(element);
      //
      //     blockDates.add(blockDate.startTime);
      //   });
      // }
      GlobalCall.blockDates = blockDates;

      return true;
    });
  }

}