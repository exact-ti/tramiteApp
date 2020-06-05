import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Configuration/config.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class Requester {
  static final Requester _instancia = new Requester._internal();

  factory Requester() {
    return _instancia;
  }

  Requester._internal();

  final Dio _dio = Dio();

  final _prefs = new PreferenciasUsuario();

  Future<Response> login(String path, dynamic data) async {
    String basic = properties['CLIENT_ID'] + ":" + properties['CLIENT_SECRET'];
    var basic8 = utf8.encode(basic);
    String basic64 = base64.encode(basic8);
    Map<String, dynamic> header = {
      'Authorization': 'Basic $basic64',
      "content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
    };

    try {
      return await Dio().post(properties['API'] + path,
          data: data, options: Options(headers: header));
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> refreshToken(String path, dynamic data) async {
    String basic = properties['CLIENT_ID'] + ":" + properties['CLIENT_SECRET'];
    var basic8 = utf8.encode(basic);
    String basic64 = base64.encode(basic8);
    Map<String, dynamic> header = {
      'Authorization': 'Basic $basic64',
      "content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
    };

    try {
      return await Dio().post(properties['API'] + path,
          data: data, options: Options(headers: header));
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> get(String url) async {
    return await addInterceptors(_dio).get(properties['API'] + url);
  }

  Future<Response> post(
      String url, dynamic data, Map<String, dynamic> params) async {
    if (params == null) {
      return await addInterceptors(_dio)
          .post(properties['API'] + url, data: data);
    } else {
      return await addInterceptors(_dio)
          .post(properties['API'] + url, data: data, queryParameters: params);
    }
  }

  dynamic requestInterceptor(RequestOptions options) async {
    var token = _prefs.token;
    options.headers.addAll({"Authorization": "Bearer $token"});
    return options;
  }

  dynamic responseInterceptor(Response response) async {
    return response;
  }

  dynamic errorInterceptor(dioError) async {
    /*print("Entro error");
    dynamic respuesta = dioError.response;
    Map<String, dynamic> contenido = respuesta.data;
    if (contenido["code"] == 401) {
      FormData formData = FormData.fromMap({
        'refresh_token': _prefs.refreshToken,
        'grant_type': 'refresh_token'
      });
      final resp = await refreshToken("/servicio-oauth/oauth/token", formData);
      Map<String, dynamic> refreshdata = resp.data;
      _prefs.token = refreshdata['access_token'];
      _prefs.refreshToken = refreshdata['refresh_token'];
      mostrarAlerta(context, "asd", "ssdf");
    }*/
    return dioError;
  }

  /* Configuraciones */

  Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) => requestInterceptor(options),
          onResponse: (Response response) => responseInterceptor(response),
          onError: (DioError dioError) => errorInterceptor(dioError)));
  }
}
