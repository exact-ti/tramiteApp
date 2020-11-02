import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/GestionPasswordController.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPageState createState() => new _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  PasswordController passwordController = new PasswordController();
  final _actualPasswordController = TextEditingController();
  final _nuevaPasswordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  String actualPassword = "";
  bool visibilidadActualPassword = true;
  bool visibilidadNuevaPassword = true;
  bool visibilidadConfirmarPassword = true;
  bool cumplirIgualdadPassword = true;
  FocusNode focusActualPassword = FocusNode();
  FocusNode focusNuevaPassword = FocusNode();
  FocusNode focusConfirmarPassword = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  bool validarSend(String dato) {
    if (dato.length == 0 ||
        _nuevaPasswordController.text.length == 0 ||
        _confirmarPasswordController.text.length == 0) {
      return false;
    } else {
      if (_nuevaPasswordController.text == _confirmarPasswordController.text) {
        return true;
      } else {
        return false;
      }
    }
  }

  void validarPassActual() async {
    if (_actualPasswordController.text.length == 0) {
      popuptoinput(context, focusActualPassword, "error", "EXACT",
          "La contraseña actual es obligatoria");
    } else {
      enfocarInputfx(context, focusNuevaPassword);
    }
  }

  void validarPassPrimera() async {
    if (_nuevaPasswordController.text.length == 0) {
      popuptoinput(context, focusNuevaPassword, "error", "EXACT",
          "Ingresar la nueva contraseña");
    } else {
      enfocarInputfx(context, focusConfirmarPassword);
    }
  }

  void validarPassSegunda() async {
    if (_confirmarPasswordController.text.length == 0) {
      popuptoinput(context, focusActualPassword, "error", "EXACT",
          "Debe confirmar la nueva contraseña");
    } else {
      validarElCambio();
    }
  }

  void validarElCambio() {
    if (actualPassword.length != 0) {
      popuptoinput(context, focusActualPassword, "error", "EXACT",
          "Debe ingresar la contraseña actual");
    } else {
      if (_nuevaPasswordController.text.length != 0) {
        popuptoinput(context, focusNuevaPassword, "error", "EXACT",
            "Debe ingresar la contraseña nueva");
      } else {
        if (_confirmarPasswordController.text.length != 0) {
          popuptoinput(context, focusNuevaPassword, "error", "EXACT",
              "Debe confirmar la nueva contraseña");
        } else {
          if (_nuevaPasswordController.text !=
              _confirmarPasswordController.text) {
            notificacion(context, "Error", "EXACT",
                "Las contraseñas nuevas no son iguales");
          } else {
            passwordController.changePassword(
                _actualPasswordController.text, _nuevaPasswordController.text);
          }
        }
      }
    }
  }

  void onPressedCambiarButton() async {
    desenfocarInputfx(context);
    if (validarSend(actualPassword)) {
      dynamic respuestaBack = await passwordController.changePassword(
          _actualPasswordController.text, _nuevaPasswordController.text);
      if (respuestaBack["status"] == "success") {
        bool respuestaPopUP = await notificacion(
            context, "success", "EXACT", "Se cambió la contraseña");
        if (respuestaPopUP) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } else {
        notificacion(context, "error", "EXACT", respuestaBack["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputActualPassword = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: visibilidadActualPassword,
      focusNode: focusActualPassword,
      autofocus: false,
      controller: _actualPasswordController,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        setState(() {
          actualPassword = value;
        });
      },
      onFieldSubmitted: (value) {
        validarPassActual();
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              visibilidadActualPassword = !visibilidadActualPassword;
            });
          },
          child: Icon(
            !visibilidadActualPassword
                ? Icons.visibility_off
                : Icons.visibility,
            size: 18,
            color: StylesThemeData.PRIMARYCOLOR,
          ),
        ),
      ),
    );

    var inputNuevaPassword = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: visibilidadNuevaPassword,
      focusNode: focusNuevaPassword,
      autofocus: false,
      controller: _nuevaPasswordController,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        if (_confirmarPasswordController.text.length != 0) {
          if (_nuevaPasswordController.text ==
              _confirmarPasswordController.text) {
            setState(() {
              cumplirIgualdadPassword = true;
            });
          } else {
            setState(() {
              cumplirIgualdadPassword = false;
            });
          }
        } else {
          setState(() {
            cumplirIgualdadPassword = true;
          });
        }
      },
      onFieldSubmitted: (value) {
        validarPassPrimera();
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              visibilidadNuevaPassword = !visibilidadNuevaPassword;
            });
          },
          child: Icon(
            !visibilidadNuevaPassword ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: StylesThemeData.PRIMARYCOLOR,
          ),
        ),
      ),
    );

    var inputConfirmarPassword = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: focusConfirmarPassword,
      controller: _confirmarPasswordController,
      obscureText: visibilidadConfirmarPassword,
      textInputAction: TextInputAction.send,
      onChanged: (value) {
        if (_nuevaPasswordController.text.length != 0) {
          if (_nuevaPasswordController.text ==
              _confirmarPasswordController.text) {
            setState(() {
              cumplirIgualdadPassword = true;
            });
          } else {
            setState(() {
              cumplirIgualdadPassword = false;
            });
          }
        } else {
          setState(() {
            cumplirIgualdadPassword = true;
          });
        }
      },
      onFieldSubmitted: (value) {
        validarPassSegunda();
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              visibilidadConfirmarPassword = !visibilidadConfirmarPassword;
            });
          },
          child: Icon(
            !visibilidadConfirmarPassword
                ? Icons.visibility_off
                : Icons.visibility,
            size: 18,
            color: StylesThemeData.PRIMARYCOLOR,
          ),
        ),
      ),
    );

    mainscaffold() {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 5),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: Text("Contraseña actual")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: inputActualPassword),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: Text("Contraseña nueva")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: inputNuevaPassword),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: Text("Confirmar contraseña nueva")),
            Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: inputConfirmarPassword),
            !cumplirIgualdadPassword
                ? Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      "Las contraseñas no son iguales",
                      style: TextStyle(color: Colors.red),
                    ))
                : Container(),
            Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: CustomButton(
                    onPressed: onPressedCambiarButton,
                    colorParam: validarSend(actualPassword)
                        ? Color(0xFF2C6983)
                        : Colors.grey[500],
                    texto: "Cambiar"))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARYCOLOR,
            title: Text("Cambiar contraseña",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }
}
