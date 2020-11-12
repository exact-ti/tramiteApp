import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/GestionPasswordController.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

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

  void validarPassActual(dynamic valueActualPassword) async {
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

  dynamic onChangedPassActual(dynamic valuePassActual) {
    setState(() {
      actualPassword = valuePassActual;
    });
  }

  dynamic onPressSufixActualPassword() {
    setState(() {
      visibilidadActualPassword = !visibilidadActualPassword;
    });
  }

  dynamic onChangedPassNueva(dynamic valuePassActual) {
    if (_confirmarPasswordController.text.length != 0) {
      if (_nuevaPasswordController.text == _confirmarPasswordController.text) {
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
  }

  dynamic onPressSufixNuevaPassword() {
    setState(() {
      visibilidadNuevaPassword = !visibilidadNuevaPassword;
    });
  }

  void validarNuevaPassword(dynamic valueActualPassword) {
    if (_nuevaPasswordController.text.length == 0) {
      popuptoinput(context, focusNuevaPassword, "error", "EXACT",
          "Ingresar la nueva contraseña");
    } else {
      enfocarInputfx(context, focusConfirmarPassword);
    }
  }

  dynamic onChangedPassConfirmar(dynamic valuePassActual) {
    if (_nuevaPasswordController.text.length != 0) {
      if (_nuevaPasswordController.text == _confirmarPasswordController.text) {
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
  }

  dynamic onPressSufixConfirmarPassword() {
    setState(() {
      visibilidadNuevaPassword = !visibilidadNuevaPassword;
    });
  }

  void validarConfirmarPassword(dynamic valueActualPassword) {
    if (_confirmarPasswordController.text.length == 0) {
      popuptoinput(context, focusActualPassword, "error", "EXACT",
          "Debe confirmar la nueva contraseña");
    } else {
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
              passwordController.changePassword(_actualPasswordController.text,
                  _nuevaPasswordController.text);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mainscaffold() {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            paddingWidget(Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10, top: 20),
                    width: double.infinity,
                    child: InputWidget(
                      iconSufix: IconsData.ICON_EYE_ENABLED,
                      methodOnPressedSufix: onPressSufixActualPassword,
                      controller: _actualPasswordController,
                      focusInput: focusActualPassword,
                      hinttext: 'Actual contraseña',
                      methodOnPressed: validarPassActual,
                      visibilityTextForm: visibilidadActualPassword,
                      methodOnChange: onChangedPassActual,
                      iconPrefix: IconsData.ICON_PADLOCK,
                    )),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: InputWidget(
                      iconSufix: IconsData.ICON_EYE_ENABLED,
                      methodOnPressedSufix: onPressSufixNuevaPassword,
                      controller: _nuevaPasswordController,
                      focusInput: focusNuevaPassword,
                      hinttext: 'Nueva contraseña',
                      methodOnPressed: validarNuevaPassword,
                      visibilityTextForm: visibilidadNuevaPassword,
                      methodOnChange: onChangedPassNueva,
                      iconPrefix: IconsData.ICON_PADLOCK,
                    )),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: InputWidget(
                      iconSufix: IconsData.ICON_EYE_ENABLED,
                      methodOnPressedSufix: onPressSufixConfirmarPassword,
                      controller: _confirmarPasswordController,
                      focusInput: focusConfirmarPassword,
                      hinttext: 'Confirmar contraseña nueva',
                      methodOnPressed: validarConfirmarPassword,
                      visibilityTextForm: visibilidadConfirmarPassword,
                      methodOnChange: onChangedPassConfirmar,
                      iconPrefix: IconsData.ICON_PADLOCK,
                    )),
                !cumplirIgualdadPassword
                    ? Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Las contraseñas no son iguales",
                          style: TextStyle(color: Colors.red),
                        ))
                    : Container(),
              ],
            )),
            paddingWidget(Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: ButtonWidget(
                    iconoButton: IconsData.ICON_PASSWORD,
                    onPressed: onPressedCambiarButton,
                    colorParam: validarSend(actualPassword)
                        ? StylesThemeData.BUTTON_PRIMARY_COLOR
                        : StylesThemeData.DISABLE_COLOR,
                    texto: "Cambiar contraseña")))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARY_COLOR,
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
