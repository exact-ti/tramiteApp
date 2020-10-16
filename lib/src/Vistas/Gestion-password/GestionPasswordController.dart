import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Password/IPasswordCore.dart';
import 'package:tramiteapp/src/CoreProyecto/Password/PasswordCore.dart';
import 'package:tramiteapp/src/Providers/password/impl/PasswordProvider.dart';

class PasswordController {
  
  IPasswordCore passwordCore = new PasswordCore(new PasswordProvider());

  Widget labeltext(String mensaje) {
    return Container(
      child: Text("$mensaje"),
      margin: const EdgeInsets.only(left: 15),
    );
  }

  Future<dynamic> submitEmail(String email) async {
    dynamic respuesta = await passwordCore.submitEmail(email);
    return respuesta;
  }

    Future<dynamic> changePassword(String passActual, String passNew) async {
    dynamic respuesta = await passwordCore.changePassword(passActual, passNew);
    return respuesta;
  }
}
