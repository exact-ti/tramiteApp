import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:intl/intl.dart';

class EnvioConfirmadoPage extends StatefulWidget {
  final UsuarioFrecuente usuariopage;

  const EnvioConfirmadoPage({Key key, this.usuariopage}) : super(key: key);

  @override
  _EnvioConfirmadoPageState createState() =>
      _EnvioConfirmadoPageState(this.usuariopage);
}

class _EnvioConfirmadoPageState extends State<EnvioConfirmadoPage> {
  UsuarioFrecuente usuarioFrecuente;

  _EnvioConfirmadoPageState(this.usuarioFrecuente);
  String fecha = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => inicializarUsuario());
    super.initState();
  }

  void inicializarUsuario() {
    if (this.mounted) {
      UsuarioFrecuente usuario = new UsuarioFrecuente();
      Map envio = ModalRoute.of(context).settings.arguments;
      var now = new DateTime.now();
      fecha = new DateFormat('dd-M-yyyy HH:mm').format(now);
      if (envio != null) {
        usuario.area = envio['area'];
        usuario.id = envio['id'];
        usuario.nombre = envio['nombre'];
        usuario.sede = envio['sede'];
        setState(() {
          this.usuarioFrecuente = usuario;
          fecha = fecha;
        });
      } else {
        setState(() {
          this.usuarioFrecuente = this.usuarioFrecuente;
          fecha = fecha;
        });
      }
    }
  }

  void onPressedNuevoEnvio() {
    Navigator.of(context).pushNamed(
      '/crear-envio',
      arguments: {
        'id': usuarioFrecuente.id,
        'area': usuarioFrecuente.area,
        'nombre': usuarioFrecuente.nombre,
        'sede': usuarioFrecuente.sede,
      },
    );
  }

  void onPressedIrInicio() {
    navegarHomeExact(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: usuarioFrecuente == null
            ? loadingGet()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Icon(
                        IconsData.ICON_CONFIRMADO,
                        color: StylesThemeData.BUTTON_PRIMARY_COLOR,
                        size: 100,
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Envío realizado",
                        style: TextStyle(
                            color: StylesThemeData.BUTTON_PRIMARY_COLOR),
                      )),
                  Card(
                    color: StylesThemeData.CARD_COLOR,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 40,
                                    child: Icon(
                                      IconsData.ICON_USER,
                                      color: StylesThemeData.ICON_COLOR,
                                    )),
                                Container(
                                    child: Text(this.usuarioFrecuente.nombre))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width: 40,
                                      child: Icon(IconsData.ICON_SEDE,
                                          color: StylesThemeData.ICON_COLOR)),
                                  Container(
                                      child: Text(this.usuarioFrecuente.area +
                                          " - " +
                                          this.usuarioFrecuente.sede))
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    child: Icon(IconsData.ICON_CALENDAR,
                                        color: StylesThemeData.ICON_COLOR),
                                  ),
                                  Container(child: Text(this.fecha))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: ButtonWidget(
                          onPressed: onPressedNuevoEnvio,
                          iconoButton: IconsData.ICON_SEND,
                          colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                          texto: "Realizar otro envío")),
                  Container(
                      child: ButtonWidget(
                          onPressed: onPressedIrInicio,
                          iconoButton: IconsData.ICON_SEDE,
                          colorParam: StylesThemeData.BUTTON_DISABLE_COLOR,
                          texto: "Ir a inicio"))
                ],
              ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Detalle de envío"),
        drawer: drawerIfPerfil(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
