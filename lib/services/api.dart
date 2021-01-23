import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/app/globals.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/models/ride_request_model.dart';
import 'package:taxiapp/models/ride_summary_model.dart';
import 'package:taxiapp/models/token_model.dart';
import 'package:taxiapp/services/storage_service.dart';
import 'package:taxiapp/services/token.dart';
import 'package:taxiapp/utils/retry/dio_retry.dart';

@lazySingleton
class Api {
  final Dio _dioBack = Dio();
  final Dio _dioMap = Dio();
  final shared = locator<Storage>();
  final token = locator<Token>();

  Api() {
    _dioBack.options.baseUrl = 'https://warzsud.herokuapp.com';
    _dioBack.options.connectTimeout = 5000;
    _dioBack.options.sendTimeout = 5000;
    _dioBack.options.receiveTimeout = 20000;
    _dioBack.interceptors.add(RetryInterceptor(
      dio: _dioBack,
      options: const RetryOptions(
        retries: 3,
        retryInterval: Duration(seconds: 5),
      ),
    ));
    (_dioBack.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dioMap.options.connectTimeout = 5000;
    _dioMap.options.sendTimeout = 5000;
    _dioMap.options.receiveTimeout = 20000;
    _dioMap.interceptors.add(RetryInterceptor(
      dio: _dioMap,
      options: const RetryOptions(
        retries: 3,
        retryInterval: Duration(seconds: 5),
      ),
    ));
    (_dioBack.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  // ignore: unused_element
  Future<dynamic> _get(String method, {Map query}) async {
    var response = await _dioBack.get(method,
        queryParameters: query,
        options: Options(
          headers: await token.buildHeaders(),
        ));
    return response.data;
  }

  Future<dynamic> _post(String method, Map data, {Map query}) async {
    var response = await _dioBack.post(method,
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
    var model = TokenModel.fromJson(response);
    return model;
  }

  Future<List<RideRequestModel>> getAllUserHistorial(String uid) async {
    var response = await _get('/rides/?idDriver=${uid}');
    var model = response.map<RideRequestModel>((i) => RideRequestModel.fromJson(i)).toList();
    return model;
  }

  Future<dynamic> getRideSummary(String uid) async {
    var response = await _get('/rides/resume/${uid}');
    return response;
  }
  // User

  // Others

  Future<String> countryCode() async {
    var response = await Dio().get('https://ipapi.co/country_code/');
    return response.data;
  }

  Future<Map> getAddress(Map data) async {
    var response = await _dioMap.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=${data['lat']},${data['lng']}&key=${Globals.googleMapsApiKey}');
    return response.data;
  }

  Future<Map> getCoords(Map data) async {
    var response = await _dioMap.get('https://maps.googleapis.com/maps/api/geocode/json?address=${data['address']}region=PE&key=${Globals.googleMapsApiKey}');
    return response.data;
  }

  Future<Map> findPlaces(Map data) async {
    var response = await _dioMap.get(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${data['query']}&inputtype=textquery&fields=formatted_address,name,geometry&locationbias=point:${data['lat']},${data['lng']}&key=${Globals.googleMapsApiKey}');
    return response.data;
  }

  Future<Map> getRouteByCoordinates(Map data) async {
    var response = await _dioMap.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${data['lat1']},${data['lng1']}&destination=${data['lat2']},${data['lng2']}&key=${Globals.googleMapsApiKey}');
    return response.data;
  }
}
