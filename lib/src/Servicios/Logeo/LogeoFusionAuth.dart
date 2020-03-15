import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:tramiteapp/src/Entity/Usuario.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import 'package:tramiteapp/src/Servicios/Logeo/LogeoInterface.dart';
import 'package:http/http.dart' as http;
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';

class LogeoFusionAuth implements LogeoInterface {

  final _prefs = new PreferenciasUsuario();

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final authData = {
      'email': username,
      'password': password,
      'grant_type': 'password'
    };

    Requester req = Requester();

    final resp = await req.login("/securiy/oauth/token", json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.data);

    return decodedResp;
  }

  Future<Map<String, dynamic>> login2(String username, String password) async {
    final authorizationEndpoint =
        'http://localhost:8890/api/security/oauth/token';

    var map = new Map<String, dynamic>();
    map['grant_type'] = 'password';
    map['username'] = username;
    map['password'] = password;

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Basic ZnJvbnRlbmRhcHA6MTIzNDU="
    };

    http.Response response =
        await http.post(authorizationEndpoint, headers: headers, body: map);

    print(response);

    var resp;

    final authData = {
      'username': username,
      'password': password,
      'returnSecureToken': true
    };

    try {
      resp = await http.post('localhost:8890/api/security/oauth/token',
          body: json.encode(authData));
    } catch (e) {
      return {'ok': false, 'mensaje': 'El servidor esta en mantenimiento.'};
    }

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {
        'ok': false,
        'mensaje': 'El Usuario y contraseña son incorrectos.'
      };
    }
  }
}
