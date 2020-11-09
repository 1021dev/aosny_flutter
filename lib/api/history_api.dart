import 'dart:convert';
import 'dart:io';
import 'package:aosny_services/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class HistoryApi{

  
  Future<List<HistoryModel>> getHistoryList({@required String sdate, @required String endDate}) async { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String providerid = prefs.getString('providerid');

    //String url = "http://aosapi.pdgcorp.com/api/Provider/051829096/history?startdate=$sdate&enddate=$endDate";
    String url = baseURL + "Provider/" + providerid + "/history?startdate=$sdate&enddate=$endDate";
    List<HistoryModel> result;

    return http.get(url,headers:  {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer $token"}).then((http.Response response) {
      int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      var data = json.decode(response.body);
      print("HISTORY DATA:$data");

      result = data.map<HistoryModel>(
              (json) => HistoryModel.fromJson(json))
          .toList();

      print("history result Size: ${result.length}");
      return result;
    });
  }

}