import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/GestionPasswordController.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class RecuperarPasswordPage extends StatefulWidget {
  @override
  _RecuperarPasswordPageState createState() =>
      new _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  final _emailController = TextEditingController();
  PasswordController passwordController = new PasswordController();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void envioValidar(BuildContext context) async {
      desenfocarInputfx(context);
      if (_emailController.text.length == 0) {
        notificacion(context, "error", "EXACT", "Ingrese el correo electrónico");
      } else {
        await passwordController.submitEmail(_emailController.text);
        bool respuestaPopUP = await notificacion(context, "success", "EXACT",
            "Te enviaremos un link para resetear tu contraseña");
        if (respuestaPopUP) {
          Navigator.of(context).pop();
        }
      }
    }

    void buttonPress() {
      if (_formKey.currentState.validate()) {
        envioValidar(context);
      }
    }

    void onChangeTextForm(valueForm) {
      setState(() => email = valueForm);
    }

    mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 10),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: passwordController.labeltext(
                    "Ingresa tu correo electrónico para recuperar tu cuenta.")),
            Container(
                margin: const EdgeInsets.only(bottom: 30),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: InputWidget(
                        validadorInput: validateEmail,
                        controller: _emailController,
                        iconPrefix: IconsData.ICON_MAIL,
                        focusInput: null,
                        methodOnChange: onChangeTextForm,
                        hinttext: 'Correo'))),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: ButtonWidget(
                    iconoButton: IconsData.ICON_SEND,
                    onPressed: buttonPress,
                    colorParam: StylesThemeData.PRIMARY_COLOR,
                    texto: 'Enviar'))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARY_COLOR,
            title: Text("Recupera tu cuenta",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: mainscaffold());
  }
}
