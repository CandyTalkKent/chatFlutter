import 'package:dio/dio.dart';

class DioUtil{


  static Future<Response> get(String path,Map<String, dynamic> queryParams) async {

    Response response;
    Dio dio = new Dio();
// Optionally the request above could also be done as
    response = await dio.get(path, queryParameters: queryParams);

    return response;
  }

}