import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/GestionPasswordController.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

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
        notificacion(
            context, "error", "EXACT", "Ingrese el correo electrónico");
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

    var formEmail = Form(
        key: _formKey,
        autovalidate: true,
        child: TextFormField(
          onChanged: (String val) => setState(() => email = val),
          keyboardType: TextInputType.text,
          validator: validateEmail,
          autofocus: false,
          controller: _emailController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {},
          decoration: InputDecoration(
            helperStyle: TextStyle(fontSize: 5),
            hintStyle: TextStyle(fontSize: 5),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            filled: true,
            fillColor: Color(0xFFEAEFF2),
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Color(0xFFEAEFF2),
                width: 0.0,
              ),
            ),
          ),
        ));

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: formEmail,
        flex: 5,
      )
    ]);

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
                child: campodetextoandIconoBandeja),
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: CustomButton(
                    onPressed: buttonPress,
                    colorParam: StylesThemeData.PRIMARYCOLOR,
                    texto: 'Enviar'))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARYCOLOR,
            title: Text("Recupera tu cuenta",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: mainscaffold());
  }
}
