import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/Enumerator/TipoPerfilEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/BottomNBPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'NotificacionesController.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  NotificacionController notificacioncontroller = new NotificacionController();
  NotificacionModel notificacionModel = new NotificacionModel();
  final _prefs = new PreferenciasUsuario();

  @override
  void initState() {
    gestionNotificaciones();
    super.initState();
  }

  retrieveData() {
    setState(() {
      notificacionModel = notificacionModel;
    });
  }

  void gestionNotificaciones() async {
    List<NotificacionModel> listanotificacionesPendientes =
        await notificacioncontroller.listarNotificacionesPendientes();
    if (this.mounted) {
      Provider.of<NotificationInfo>(context, listen: false)
              .cantidadNotificacion =
          listanotificacionesPendientes
              .where(
                  (element) => element.notificacionEstadoModel.id == pendiente)
              .toList()
              .length;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(NotificacionModel notificacionModel) {
      return InkWell(
          onTap: () async {
            dynamic respuestaController = await notificacioncontroller
                .visitarNotificacion(notificacionModel.id);
            if (respuestaController["status"] == "success") {
              if (_prefs.tipoperfil == cliente) {
                Navigator.of(context, rootNavigator: true)
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            new TopLevelWidget(rutaPage: notificacionModel.ruta)))
                    .whenComplete(retrieveData());
              } else {
                Navigator.pushNamed(context, notificacionModel.ruta)
                    .whenComplete(retrieveData());
              }
            } else {
              notificacion(context, "error", "EXACT", "Surgió un problema");
            }
          },
          child: Container(
              height: 70,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color:  Colors
                    .white,
                border: new Border(bottom: BorderSide(color: Colors.grey[300])),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(notificacionModel.mensaje,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[300])))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(notificacionModel.fecha,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFFACADAD)))))
                ],
              )));
    }

    Widget _crearListado(notificacionModel) {
      return FutureBuilder(
          future: notificacioncontroller.listarNotificacionesPendientes(),
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificacionModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor",IconsData.ICON_ERROR_SERVIDOR);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados("Ha surgido un problema",IconsData.ICON_ERROR_PROBLEM);
                } else {
                  if (snapshot.hasData) {
                    final notificaciones = snapshot.data;
                    if (notificaciones.length == 0) {
                      return sinResultados("No hay notificaciones pendientes",IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: notificaciones.length,
                          itemBuilder: (context, i) =>
                              crearItem(notificaciones[i]));
                    }
                  } else {
                    return sinResultados("No hay notificaciones pendientes",IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    Widget mainscaffold() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: _crearListado(notificacionModel)),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: StylesThemeData.PRIMARY_COLOR,
            title: Text("Notificaciones",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
