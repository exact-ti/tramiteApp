import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'loginController.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  bool pressbutton = true;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      if (int.parse(sharedPreferences.getString("perfil")) == cliente) {
        if (sharedPreferences.getString("buzon") != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      } else {
        if (sharedPreferences.getString("utd") != null || sharedPreferences.getString("buzon") != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    LoginController logincontroller = new LoginController();

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 90.0,
          child: Image.asset('assets/usuariologin.png'),
        ));

    void enfocarcodigocontrasena() {
      FocusScope.of(context).unfocus();
      enfocarInputfx(context, f2);
    }

    var email = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autofocus: false,
      focusNode: f1,
      onFieldSubmitted: (value) {
        enfocarcodigocontrasena();
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: Color(0xffF0F3F4),
        hintText: 'Usuario',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      ),
    );

    performLogin(BuildContext context) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      if (username == "" || password == "") {
        notificacion(
            context, "error", "EXACT", "Ingrese todos los datos solicitados");
      } else {
        logincontroller.validarlogin(context, username, password);
      }
      setState(() {
        pressbutton = true;
      });
    }

    void enfocarUsuarioOrContrasena() {
      FocusScope.of(context).unfocus();
      if (_usernameController.text.length == 0) {
        enfocarInputfx(context, f1);
      } else {
        if (pressbutton) {
          pressbutton = false;
          performLogin(context);
        }
      }
    }

    final password = TextFormField(
      controller: _passwordController,
      autofocus: false,
      obscureText: true,
      textAlign: TextAlign.center,
      focusNode: f2,
      onFieldSubmitted: (value) async {
        enfocarUsuarioOrContrasena();
      },
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Color(0xffF0F3F4),
        hintText: 'contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 70),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
          if (pressbutton) {
            pressbutton = false;
            performLogin(context);
          }
        },
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        color: Colors.lightBlueAccent,
        child: Text('LOG IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final titulo = Text(
      'Login',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blueGrey),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          titulo,
          SizedBox(height: 24.0),
          logo,
          SizedBox(height: 48.0),
          email,
          SizedBox(height: 8.0),
          password,
          SizedBox(height: 24.0),
          loginButton,
        ],
      )),
    );
  }
}
