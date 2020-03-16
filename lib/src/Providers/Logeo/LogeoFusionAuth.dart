import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class LogeoFusionAuth implements LogeoInterface {

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    FormData formData = FormData.fromMap(
        {'username': username, 'password': password, 'grant_type': 'password'});
    Requester req = Requester();
    final resp = await req.login("/security/oauth/token", formData);
    Map<String, dynamic> decodedResp = resp.data;
    return decodedResp;
  }
}
