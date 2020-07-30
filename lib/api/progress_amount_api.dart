import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class ProgressAmountApi{
    
    Future<List<ProgressAmountModel>> getProgressAmountList(String startDate, String endDate) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String providerid = prefs.getString('providerid');

    //String url = "http://aosapi.pdgcorp.com/api/Provider/051829096/progress?startdate=$sdate&enddate=$endDate";
    String url = baseURL + "Provider/" + providerid + "/progress?startdate=$startDate&enddate=$endDate";
    print('URL:::$url');
    print('Token:::$token');
    List<ProgressAmountModel> result;

    return http.get(url,headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}).then((http.Response response) {
      int statusCode = response.statusCode;
      
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("PROGRESS AMOUNT DATA:$data");

      result = data.map<ProgressAmountModel>(
              (json) => ProgressAmountModel.fromJson(json))
          .toList();

      print("Progress Amount result Size: ${result.length}");
      return result;
    });
  }

}