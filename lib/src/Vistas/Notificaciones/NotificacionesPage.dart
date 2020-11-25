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
import 'package:tramiteapp/src/styles/Title_style.dart';
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

  void verNotificaciones() {
    notificacioncontroller.verNotificaciones();
                  Provider.of<NotificationInfo>(context, listen: false)
                  .cantidadNotificacion = 0;
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
                        builder: (context) => new TopLevelWidget(
                            rutaPage: notificacionModel.ruta)))
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
              height: 100,
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: notificacionModel.notificacionEstadoModel.id == pendiente
                    ? StylesThemeData.ITEM_SELECT_COLOR
                    : Colors.white,
                border: new Border(bottom: BorderSide(color: Colors.grey[300])),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Stack(
                      children: <Widget>[
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          color: StylesThemeData.PRIMARY_COLOR,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                  child: Icon(
                                IconsData.ICON_FILE,
                                color: Colors.white,
                                size: 40,
                              )),
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 1,
                          child: Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Color(0xFF269FC0),
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(
                                    child: Icon(
                                  IconsData.ICON_NOTIFICATIONS,
                                  color: Colors.white,
                                  size: 10,
                                )),
                                width: 8,
                                height: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: new Container(
                            padding: new EdgeInsets.only(right: 13.0),
                            child: new Text(
                              notificacionModel.mensaje,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: new Container(
                                padding: new EdgeInsets.only(right: 13.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        IconsData.ICON_CALENDAR,
                                        size: 13,
                                        color: StylesThemeData.ICON_COLOR,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          notificacionModel.fecha,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: StylesTitleData.STYLE_SUBTILE,
                                        )),
                                  ],
                                )),
                          ),
                          flex: 1)
                    ],
                  ))
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
                return sinResultados("No hay conexión con el servidor",
                    IconsData.ICON_ERROR_SERVIDOR);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados(
                      "Ha surgido un problema", IconsData.ICON_ERROR_PROBLEM);
                } else {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                        verNotificaciones();
                    });
                    final notificaciones = snapshot.data;
                    if (notificaciones.length == 0) {
                      return sinResultados("No hay notificaciones pendientes",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: notificaciones.length,
                          itemBuilder: (context, i) =>
                              crearItem(notificaciones[i]));
                    }
                  } else {
                    return sinResultados("No hay notificaciones pendientes",
                        IconsData.ICON_ERROR_EMPTY);
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
