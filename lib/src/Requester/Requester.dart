import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Configuration/config.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Resources/conection-sse/sse.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';

class Requester {
  static final Requester _instancia = new Requester._internal();
  final NavigationService _navigationService = locator<NavigationService>();
  NotificacionModel notificacionModel = new NotificacionModel();
  int tipoPeticion = 0;
  bool respuesta = false;
  factory Requester() {
    return _instancia;
  }
  Requester._internal();
  final Dio _dio = Dio();
  final _prefs = new PreferenciasUsuario();

  Future<Response> login(String path, String username, String password) async {
    String basic = username + ":" + password;
    var basic8 = utf8.encode(basic);
    String basic64 = base64.encode(basic8);

    Map<String, dynamic> header = {
      'Authorization': 'Basic $basic64',
      "content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
    };

    try {
      Response token = await Dio().post(
          properties['LDAP']
              ? properties['API'] + path + "/ldap"
              : properties['API'] + path,
          options: Options(headers: header));
      return token;
    } on DioError catch (e) {
      _navigationService.goBack();
      _navigationService.modelInformativo(
          "error", "EXACT", "Error. Ha surgido un problema!");
      return e.response;
    }
  }

  Future<Response> refreshToken(String path, dynamic refreshToken) async {
    Map<String, dynamic> header = {
      'Authorization': 'Bearer  $refreshToken',
      "content-type": "application/json",
    };
    try {
      Response refreshtoken = await Dio()
          .post(properties['API'] + path, options: Options(headers: header));
      return refreshtoken;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> get(String url) async {
    Response respuestaGet =
        await addInterceptors(_dio).get(properties['API'] + url);

    return respuestaGet;
  }

  Future<EventSource> sseventSource(String url) async {
    var token = _prefs.token;
    Map<String, dynamic> header = {
      'Authorization': "Bearer $token"
    };  
    
    EventSource eventSource =  await EventSource.conectar(properties['API'] + url, headers: header);
    return eventSource;
  }

  Future<Response> put(String url, dynamic data, dynamic params) async {
    _navigationService.showModal();
    Response respuestaPost = await addInterceptors(_dio).put(
      properties['API'] + url,
      data: data,
      queryParameters: params,
    );
    _navigationService.goBack();
    return respuestaPost;
  }

  Future<Response> post(String url, dynamic data, dynamic params) async {
    _navigationService.showModal();
    Response respuestaPost = await addInterceptors(_dio).post(
      properties['API'] + url,
      data: data,
      queryParameters: params,
    );
    _navigationService.goBack();
    return respuestaPost;
  }

  Future<Response> postEmail(String path, dynamic paramEmail) async {
    try {
      _navigationService.showModal();
      Response repuesta = await Dio()
          .post(properties['API'] + path, queryParameters: paramEmail);
      _navigationService.goBack();

      return repuesta;
    } on DioError catch (e) {
      _navigationService.goBack();
      _navigationService.modelInformativo(
          "error", "EXACT", "Error. Ha surgido un problema!");
      return e.response;
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

  dynamic errorInterceptor(DioError dioError) async {
    if(dioError.response==null) return dioError;
    dynamic data = dioError.response.data;
    if (data != null) {
      Response response;
      final resp = await refreshToken(
          "/servicio-auth/auth/refresh", _prefs.refreshToken);
      if (resp.statusCode == 200) {
        dynamic refreshdata = resp.data;
        dynamic dataCore = refreshdata["data"];
        _prefs.token = dataCore['access_token'];
        _prefs.refreshToken = dataCore['refresh_token'];
        RequestOptions request = dioError.request;
        switch (request.method) {
          case "GET":
            response = await this
                .get(request.path.substring(properties['API'].length));
            break;
          case "POST":
            response = await this.post(
                request.path.substring(properties['API'].length),
                request.data,
                request.queryParameters);
            break;
          default:
            return dioError;
        }
        return response;
      } else {
        if (!respuesta) {
          this.respuesta = true;
          _navigationService.modelInformativo("success", "Sesión terminada",
              "La sesión terminó, debe volver a logearse");
        }
        return dioError;
      }
    } else {
      RequestOptions request = dioError.request;
      switch (request.method) {
        case "PUT":
          _navigationService.goBack();
          _navigationService.modelInformation(
              "error", "EXACT", "Error. Ha surgido un problema!");
          break;
        case "POST":
          _navigationService.goBack();
          _navigationService.modelInformation(
              "error", "EXACT", "Error. Ha surgido un problema!");
          break;
        default:
          return dioError;
      }
    }
    return dioError;
  }

  Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) => requestInterceptor(options),
          onResponse: (Response response) => responseInterceptor(response),
          onError: (DioError dioError) => errorInterceptor(dioError)));
  }
}
