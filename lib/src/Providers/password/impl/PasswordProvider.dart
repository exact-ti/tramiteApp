import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IPasswordProvider.dart';

class PasswordProvider implements IPasswordProvider {
  Requester req = Requester();

  String serviceBack = "/servicio-usuario/";

  @override
  Future submitEmail(String email) async {
    final Map<String, dynamic> parametro = {
      "correo": email,
    };
    Response resp = await req.postEmail(serviceBack + "login/reset/solicitud" , parametro);
    return resp.data;
  }

  @override
  Future changePassword(String passActual, String passNew) async {
    final formData = json.encode({
      "passwordActual": passActual,
      "passwordNuevo": passNew,
    });
    Response resp = await req.put(
        serviceBack + 'usuarios/autenticado/password', formData, null);
    return resp.data;
  }
}
