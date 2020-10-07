import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/GestionPasswordController.dart';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPageState createState() => new _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  final _actualController = TextEditingController();
  final _primeraCController = TextEditingController();
  final _segundaCController = TextEditingController();
  String actualString = "";
  bool passwordVisible1 = true;
  bool passwordVisible2 = true;
  bool passwordVisible3 = true;
  bool passwordIgualdad = true;
  PasswordController passwordController = new PasswordController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  bool validarSend(String dato) {
    if (dato.length == 0 ||
        _primeraCController.text.length == 0 ||
        _segundaCController.text.length == 0) {
      return false;
    } else {
      if (_primeraCController.text == _segundaCController.text) {
        return true;
      } else {
        return false;
      }
    }
  }

  void validarPassActual() async {
    if (_actualController.text.length == 0) {
      popuptoinput(
          context, f1, "error", "EXACT", "La contraseña actual es obligatoria");
    } else {
      enfocarInputfx(context, f2);
    }
  }

  void validarPassPrimera() async {
    if (_primeraCController.text.length == 0) {
      popuptoinput(
          context, f2, "error", "EXACT", "Ingresar la nueva contraseña");
    } else {
      enfocarInputfx(context, f3);
    }
  }

  void validarPassSegunda() async {
    if (_segundaCController.text.length == 0) {
      popuptoinput(
          context, f1, "error", "EXACT", "Debe confirmar la nueva contraseña");
    } else {
      validarElCambio();
    }
  }

  void validarElCambio() {
    if (actualString.length != 0) {
      popuptoinput(
          context, f1, "error", "EXACT", "Debe ingresar la contraseña actual");
    } else {
      if (_primeraCController.text.length != 0) {
        popuptoinput(
            context, f2, "error", "EXACT", "Debe ingresar la contraseña nueva");
      } else {
        if (_segundaCController.text.length != 0) {
          popuptoinput(context, f2, "error", "EXACT",
              "Debe confirmar la nueva contraseña");
        } else {
          if (_primeraCController.text != _segundaCController.text) {
            notificacion(context, "Error", "EXACT",
                "Las contraseñas nuevas no son iguales");
          } else {
            passwordController.changePassword(
                _actualController.text, _primeraCController.text);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sendButton2 = Container(
        child: ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () async {
            desenfocarInputfx(context);
            if (validarSend(actualString)) {
              dynamic respuestaBack = await passwordController.changePassword(
                  _actualController.text, _primeraCController.text);
              if (respuestaBack["status"] == "success") {
                bool respuestaPopUP = await notificacion(
                    context, "success", "EXACT", "Se cambió la contraseña");
                if (respuestaPopUP) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              } else {
                notificacion(
                    context, "error", "EXACT", respuestaBack["message"]);
              }
            }
          },
          color:
              validarSend(actualString) ? Color(0xFF2C6983) : Colors.grey[500],
          child: Text('Cambiar', style: TextStyle(color: Colors.white))),
    ));

    var actualText = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: passwordVisible1,
      focusNode: f1,
      autofocus: false,
      controller: _actualController,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        setState(() {
          actualString = value;
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
              passwordVisible1 = !passwordVisible1;
            });
          },
          child: Icon(
            !passwordVisible1 ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: primaryColor,
          ),
        ),
      ),
    );

    var primeraText = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: passwordVisible2,
      focusNode: f2,
      autofocus: false,
      controller: _primeraCController,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        if (_segundaCController.text.length != 0) {
          if (_primeraCController.text == _segundaCController.text) {
            setState(() {
              passwordIgualdad = true;
            });
          } else {
            setState(() {
              passwordIgualdad = false;
            });
          }
        } else {
          setState(() {
            passwordIgualdad = true;
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
              passwordVisible2 = !passwordVisible2;
            });
          },
          child: Icon(
            !passwordVisible2 ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: primaryColor,
          ),
        ),
      ),
    );

    var segundaText = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f3,
      controller: _segundaCController,
      obscureText: passwordVisible3,
      textInputAction: TextInputAction.send,
      onChanged: (value) {
        if (_primeraCController.text.length != 0) {
          if (_primeraCController.text == _segundaCController.text) {
            setState(() {
              passwordIgualdad = true;
            });
          } else {
            setState(() {
              passwordIgualdad = false;
            });
          }
        } else {
          setState(() {
            passwordIgualdad = true;
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
              passwordVisible3 = !passwordVisible3;
            });
          },
          child: Icon(
            !passwordVisible3 ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: primaryColor,
          ),
        ),
      ),
    );

    mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.bottomLeft,
                  width: double.infinity,
                  child: passwordController.labeltext("Contraseña actual")),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: actualText),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomLeft,
                  width: double.infinity,
                  child: passwordController.labeltext("Contraseña nueva")),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: primeraText),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomLeft,
                  width: double.infinity,
                  child: passwordController
                      .labeltext("Confirmar contraseña nueva")),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: segundaText),
            ),
            !passwordIgualdad
                ? Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      "Las contraseñas no son iguales",
                      style: TextStyle(color: Colors.red),
                    ))
                : Container(),
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  height: screenHeightExcludingToolbar(context, dividedBy: 8),
                  width: double.infinity,
                  child: sendButton2),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text("Cambiar contraseña",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
