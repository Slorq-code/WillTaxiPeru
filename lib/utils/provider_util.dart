import 'package:dio/dio.dart';

class ProviderUtil {

  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;

  ProviderUtil({this.baseUrl, this.connectTimeout = 60000, this.receiveTimeout = 60000});

  Future<Response> requestPost(String path, Map<String, dynamic> headers, Map<String, dynamic> parameters, {String contentType = 'application/json'}) async {

    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      contentType: contentType,
      headers: headers
    );

    var dio = Dio(options);
    /*
     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
       (HttpClient client) {
      client.badCertificateCallback =
           (X509Certificate cert, String host, int port) => true;
    };
    */
    var response = await dio.post(path, data: parameters,);
      
    return response;
  }

  Future<Response> requestGet(String path, Map<String, dynamic> headers) async {

    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers
    );

    var dio = Dio(options);
    /*
     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
       (HttpClient client) {
      client.badCertificateCallback =
           (X509Certificate cert, String host, int port) => true;
    };
    */
      
    var response = await dio.get(path);
      
    return response;
  }
}