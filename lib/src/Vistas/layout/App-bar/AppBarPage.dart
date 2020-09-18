import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesController.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';

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
    gestionNotificacioneStream();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  void gestionNotificacioneStream() {
    Stream<List<NotificacionModel>> notificacionesStream =
        appBarController.esucharnotificaciones3();
    notificacionesStream.listen((event) {
      if (estadoApp == paused) {
        event.length > 1
            ? notificacionController.mostrarNotificacionPush(
                "tiene ${event.length}  notificaciones nuevas",
                "/notificaciones",
                context)
            : notificacionController.mostrarNotificacionPush(
                event[0].mensaje, event[0].ruta, context);
      }
      setState(() {
        listanotificacionesSinVer = event;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget myAppBarIcon() {
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
            listanotificacionesSinVer.length < 100
                ? listanotificacionesSinVer.length != 0
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
                                listanotificacionesSinVer.length.toString(),
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
                            listanotificacionesSinVer.length.toString(),
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
