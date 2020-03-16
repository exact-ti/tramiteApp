import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Login/loginController.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

    final email = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: Color(0xffF0F3F4),
        hintText: 'login',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final password = TextFormField(
      controller: _passwordController,
      autofocus: false,
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Color(0xffF0F3F4),
        hintText: 'password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    performLogin(BuildContext context) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      logincontroller.validarlogin(context, username, password);
    }

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 70),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          performLogin(context);
          //Navigator.of(context).pushNamed("principal");
        },
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        color: Colors.lightBlueAccent,
        child: Text('LOG IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final titulo = Text(
      'login',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blueGrey),
    );

/* 
    final letrafooter = Text(
      'Forgot password?',
      textAlign: TextAlign.center,
       overflow: TextOverflow.ellipsis,
         style: TextStyle( fontSize: 18,color: Colors.lightBlue ),
    ); */

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
