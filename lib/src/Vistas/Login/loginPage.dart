import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/widgets/FadeAnimation.dart';
import 'package:tramiteapp/src/Vistas/gestion-password/RecuperarPasswordPage.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'loginController.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  bool pressbutton = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  bool passwordVisible = true;
  String password = "";
    FocusNode _focusNode;

  @override
  void initState() {
        _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _usernameController.clear();
      if (_focusNode.hasFocus) _passwordController.clear();
    });
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      if (boolIfPerfil()) {
        if (sharedPreferences.getString("buzon") != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/menuBottom', (Route<dynamic> route) => false);
        }
      } else {
        if (sharedPreferences.getString("utd") != null ||
            sharedPreferences.getString("buzon") != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              rutaPrincipal(), (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginController logincontroller = new LoginController();

    final logo = Image.asset(
      'assets/images/logo-header.PNG',
      width: 250.0,
    );

    void enfocarcodigocontrasena() {
      FocusScope.of(context).unfocus();
      enfocarInputfx(context, f2);
    }

    var email = TextFormField(
      controller: _usernameController,
      obscureText: false,
      focusNode: f1,
      cursorColor: StylesThemeData.PRIMARY_COLOR,
      style: TextStyle(
        color: StylesThemeData.PRIMARY_COLOR,
        fontSize: 20.0,
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (newValue) {
        enfocarcodigocontrasena();
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: StylesThemeData.PRIMARY_COLOR),
        focusColor: StylesThemeData.PRIMARY_COLOR,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StylesThemeData.PRIMARY_COLOR),
        ),
        labelText: "Usuario",
        prefixIcon: Icon(
          Icons.account_circle,
          size: 20,
          color: StylesThemeData.PRIMARY_COLOR,
        ),
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
      obscureText: passwordVisible,
      controller: _passwordController,
      focusNode: f2,
      cursorColor: StylesThemeData.PRIMARY_COLOR,
      style: TextStyle(
        color: StylesThemeData.PRIMARY_COLOR,
        fontSize: 20.0,
      ),
      onFieldSubmitted: (value) async {
        enfocarUsuarioOrContrasena();
      },
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: StylesThemeData.PRIMARY_COLOR),
        focusColor: StylesThemeData.PRIMARY_COLOR,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StylesThemeData.PRIMARY_COLOR),
        ),
        labelText: "Contraseña",
        prefixIcon: Icon(
          Icons.lock,
          size: 20,
          color: StylesThemeData.PRIMARY_COLOR,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          child: Icon(
            !passwordVisible ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: StylesThemeData.PRIMARY_COLOR,
          ),
        ),
      ),
    );

    final loginButton = Material(
      child: Ink(
        decoration: BoxDecoration(
          color: StylesThemeData.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60.0,
            child: Center(
              child: Text(
                'Ingresar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
            if (pressbutton) {
              pressbutton = false;
              performLogin(context);
            }
          },
        ),
      ),
    );

    final titulo = Text(
      'Bienvenidos',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: StylesThemeData.PRIMARY_COLOR),
    );

    final enlace = InkWell(
      child: Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(
          color: StylesThemeData.PRIMARY_COLOR,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
      onTap: () {
        desenfocarInputfx(context);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: RecuperarPasswordPage(),
          ),
        );
      },
    );

    Widget mainscaffold() {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 60),
            height: screenHeightExcludingToolbar(context, dividedBy: 2),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeAnimation(1.7, titulo),
                SizedBox(height: 20.0),
                FadeAnimation(1.7, logo),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 24.0),
                      FadeAnimation(1.7, email),
                      SizedBox(height: 8.0),
                      FadeAnimation(1.7, password),
                      SizedBox(height: 24.0),
                      FadeAnimation(1.7, loginButton),
                      SizedBox(height: 8.0),
                      FadeAnimation(1.7, enlace),
                    ],
                  )))
        ],
      ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: scaffoldbodyLogin(mainscaffold(), context));
  }
}
