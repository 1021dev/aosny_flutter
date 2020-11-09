import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/category_list.dart';
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

    for (String key in preloadKeys) {
      await PreLoadApi().getPreLoadData(key);
    }
    print('load all');
    return true;
  }

  Future<CategoryList> getPreLoadData(String type) async {

    String url =  baseURL + "PreLoad/$type";
    CategoryList result;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token') ?? '';
    if (token == '') {
      return result;
    }
    return http.get(url,
        headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}
    ).then((http.Response response) {
      int statusCode = response.statusCode;

      print("Code::$type");
      print(statusCode);

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("$type => $data");

      result = CategoryList.fromJson(data);

      print(" $type result List Size: ${result.categoryData.length}");

      switch (type) {
        case "SocialPragmatics":
          GlobalCall.socialPragmatics = result;
          return result;
        case "SEITIntervention":
          GlobalCall.SEITIntervention = result;
          return result;
        case "CompletedActivity":
          GlobalCall.completedActivity = result;
          return result;
        case "JointAttention":
          GlobalCall.jointAttention = result;
          return result;
        case "Activities":
          GlobalCall.activities = result;
          return result;
        case "Outcomes":
          GlobalCall.outcomes = result;
          return result;
      }
      return result;
    });
  }

}