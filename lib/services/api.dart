import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/tokenModel.dart';
import 'package:taxiapp/services/storage_service.dart';
import 'package:taxiapp/services/token.dart';
import 'package:taxiapp/utils/retry/dio_retry.dart';

@lazySingleton
class Api {
  Dio dio = Dio();
  final shared = locator<Storage>();
  final token = locator<Token>();

  Api() {
    dio.options.baseUrl = 'https://warzsud.herokuapp.com';
    dio.options.connectTimeout = 5000;
    dio.options.sendTimeout = 5000;
    dio.options.receiveTimeout = 20000;
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      options: const RetryOptions(
        retries: 3,
        retryInterval: Duration(seconds: 5),
      ),
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  // ignore: unused_element
  Future<dynamic> _get(String method, {Map query}) async {
    var response = await dio.get(method,
        queryParameters: query,
        options: Options(
          headers: await token.buildHeaders(),
        ));
    return response.data;
  }

  Future<dynamic> _post(String method, Map data, {Map query}) async {
    var response = await dio.post(method,
        queryParameters: query,
        data: jsonEncode(data),
        options: Options(
          headers: await token.buildHeaders(),
        ));
    return response.data;
  }

  Future<void> refreshToken() async {
    Map json = await _post('refresh', {}, query: {'email': await shared.getString('email')});
    await token.saveToken(json['token']);
    return;
  }

  Future<TokenModel> inSessionUser() async {
    var response = await _post('/token/verify', {}).timeout(const Duration(milliseconds: 10000));
    var tokenModel = TokenModel.fromJson(response);
    return tokenModel;
  }
  // User

  // Others

  Future<String> countryCode() async {
    var response = await Dio().get('https://ipapi.co/country_code/');
    return response.data;
  }
}
