import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'notificationProvider.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigationTo(String routeName) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  Future<dynamic> navigationToHome(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  goBack() {
    navigatorKey.currentState.pop();
  }

  realizarnotificacion(int cantidad) {
    Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false)
        .cantidadNotificacion = cantidad;
  }

  int retornarEstado() {
    int indiceEstadoApp = Provider.of<NotificationInfo>(
            navigatorKey.currentContext,
            listen: false)
        .estadoApp;
    return indiceEstadoApp;
  }

  int estadoFinalizar() {
    int indiceFinalizarApp = Provider.of<NotificationInfo>(
            navigatorKey.currentContext,
            listen: false)
        .finalizarSubcripcion;
    return indiceFinalizarApp;
  }

  inicializarProvider() {
    Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false)
        .estadoApp = 0;
    Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false)
        .cantidadNotificacion = 0;
    Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false)
        .finalizarSubcripcion = 0;
  }

  modelInformativo(String tipo, String titulo, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('$titulo',
                        style: TextStyle(
                            color: tipo == "success"
                                ? Colors.blue[200]
                                : Colors.red[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 3.0,
                        color: tipo == "success"
                            ? Colors.blue[200]
                            : Colors.red[200]),
                  ),
                )),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: Text(mensaje),
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 20, top: 20),
              ),
              InkWell(
                onTap: () {
                  eliminarpreferences(context);
                  this.navigationTo('/login');
                },
                child: Center(
                    child: Container(
                        height: 50.00,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            top:
                                BorderSide(width: 3.0, color: Colors.grey[100]),
                          ),
                        ),
                        child: Container(
                          child: Text('Aceptar',
                              style: TextStyle(color: Colors.black)),
                        ))),
              )
            ]),
            contentPadding: EdgeInsets.all(0),
          );
        });
  }

  modelInformation(String tipo, String titulo, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('$titulo',
                        style: TextStyle(
                            color: tipo == "success"
                                ? Colors.blue[200]
                                : Colors.red[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 3.0,
                        color: tipo == "success"
                            ? Colors.blue[200]
                            : Colors.red[200]),
                  ),
                )),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: Text(mensaje),
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 20, top: 20),
              ),
              InkWell(
                onTap: () {
                  navigatorKey.currentState.pop();
                },
                child: Center(
                    child: Container(
                        height: 50.00,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            top:
                                BorderSide(width: 3.0, color: Colors.grey[100]),
                          ),
                        ),
                        child: Container(
                          child: Text('Aceptar',
                              style: TextStyle(color: Colors.black)),
                        ))),
              )
            ]),
            contentPadding: EdgeInsets.all(0),
          );
        });
  }

  void showModal() {
    Widget alert = WillPopScope(
        onWillPop: () {},
        child: AlertDialog(
          content: loadingGet(),
        ));
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
