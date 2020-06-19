import 'package:dio/dio.dart';

abstract class BaseApi {
 
  /// Get dio instance without renew token for authentication and renewtoken invocation
  dio() {
    Dio dio = Dio();

    dio.options.connectTimeout = 60000; //5s
    dio.options.receiveTimeout = 60000;
    return dio;
  }

 
  /// Get dio instance with valid token for all the api call.
  // Future<Dio> getDio() async {
  //   Dio dio;

  //   if (await validateTokenForApi()) {
  //     dio = Dio();

  //     dio.options.connectTimeout = 60000;
  //     dio.options.receiveTimeout = 60000;
  //     dio.options.validateStatus = (int status) {
  //       return status > 0;
  //     };
  //     return dio;
  //   }
  // }

}
