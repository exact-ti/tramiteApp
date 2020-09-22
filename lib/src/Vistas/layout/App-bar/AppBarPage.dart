import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Configuration/config.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesController.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';

import 'AppBarController.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  @override
  final Size preferredSize;
  CustomAppBar({
    @required this.text,
  }) : preferredSize = Size.fromHeight(56.0);

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppBarState();
  }
}

class _CustomAppBarState extends State<CustomAppBar>
    with WidgetsBindingObserver {
  AppBarController appBarController = new AppBarController();
  NotificacionController notificacionController = new NotificacionController();
  List<NotificacionModel> listanotificacionesSinVer = new List();
  NotificacionModel notificacionModel = new NotificacionModel();
  int estadoApp;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index != inactivo) {
      setState(() {
        estadoApp = state.index;
      });
    }
  }

  @override
  void initState() {
    listanotificacionesSinVer = [];
    estadoApp = 0;
    gestionNotificaciones();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    gestionNotificacioneFutures();
  }

  void gestionNotificaciones() async {
    List<NotificacionModel> listanotificacionesPendientes =
        await appBarController.listarNotificacionesPendientes();
    if (this.mounted) {
      setState(() {
        listanotificacionesSinVer = listanotificacionesPendientes
            .where((element) => element.notificacionEstadoModel.id == pendiente)
            .toList();
      });
    }
  }

  void gestionNotificacioneFutures() async {
    EventSource notificacionesStream =
        await appBarController.ssEventSource();
    notificacionesStream.listen((event) {
      print(event.data + widget.text);
      dynamic respuesta = jsonDecode(event.data);
      if (respuesta["status"] == "success") {
      List<NotificacionModel> listarNotificaciones = notificacionModel.fromJsonToNotificacion(respuesta["data"]);
              if (estadoApp == paused) {
        listarNotificaciones.length > 1
            ? notificacionController.mostrarNotificacionPush(
                "tiene ${listarNotificaciones.length}  notificaciones nuevas",
                "/notificaciones",
                context)
            : notificacionController.mostrarNotificacionPush(
                listarNotificaciones[0].mensaje, listarNotificaciones[0].ruta, context);
      }
        setState(() {
          listanotificacionesSinVer =listarNotificaciones;
        });
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
/*     appBarController.esucharnotificaciones5(context);
 */
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
/*     sse5( context); */
  }

  @override
  Widget build(BuildContext context) {
    final notificationInfo = Provider.of<NotificationInfo>(context);
    Widget myAppBarIcon() {
      int cantidadNotificaciones = listanotificacionesSinVer.length;
      return Container(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            cantidadNotificaciones < 100
                ? cantidadNotificaciones != 0
                    ? Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 5),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffc32c37),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: Text(
                                cantidadNotificaciones
                                    .toString(),
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
                : Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffc32c37),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            cantidadNotificaciones.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

/*     Widget futuremyAppBarIcon() {
      return Container(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            FutureBuilder(
                future: appBarController.esucharnotificaciones4(),
                builder: (BuildContext context,
                    AsyncSnapshot<EventSource> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("x");
                    case ConnectionState.waiting:
                      return Text("x");
                    default:
                      if (snapshot.hasError) {
                        return Text("x");
                      } else {
                        if (snapshot.hasData) {
                          EventSource notificacionesStream  = snapshot.data;
                          int cantidad = 0;
                          notificacionesStream.listen((event) {
                            print(event.data);
                              dynamic respuesta = jsonDecode(event.data);
                              if (respuesta["status"] == "success") {
                               cantidad = notificacionModel.fromJsonToNotificacion(respuesta["data"]).length;
                              }
                          });
                         return Container(child: Text("$cantidad"),);
                        } else {
                          return Text("x");
                        }
                      }
                  }
                })
          ],
        ),
      );
    } */

    return AppBar(
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: myAppBarIcon(),
            onPressed: () async {
              dynamic respuestaBack =
                  await appBarController.verNotificaciones();
              if (respuestaBack["status"] == "success") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificacionesPage(),
                  ),
                ).whenComplete(gestionNotificaciones);
              } else {
                notificacion(
                    context, "error", "EXACT", "Ha surgido un problema");
              }
            },
          ),
        ],
        title: Text(widget.text,
            style: TextStyle(
                fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal)));
  }
}
