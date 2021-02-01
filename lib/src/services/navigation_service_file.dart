import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/ModelDto/CargoModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/BottomNBPage.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'notificationProvider.dart';
import 'package:avatar_glow/avatar_glow.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigationTo(String routeName) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  Future<dynamic> navigationClienteTo(String routeName) {
    return navigatorKey.currentState.pushReplacement(MaterialPageRoute(
        builder: (context) => new TopLevelWidget(rutaPage: routeName)));
  }

  
  Future<dynamic> navigationClienteToNotifications(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName,arguments: {'notificacionPush': true});
  }

    Future<dynamic> navigationClienteToOneNotification(String routeName) {
    return navigatorKey.currentState.pushReplacement(MaterialPageRoute(
        builder: (context) => new TopLevelWidget(rutaPage: routeName)));
  }

  Future<dynamic> navigationToHome(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigationExactToNotifications(String routeName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }
  
  Future<dynamic> navigationNotificaciones() {
    return navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => NotificacionesPage()));
  }

  goBack() {
    navigatorKey.currentState.pop();
  }

  setCantidadNotificacionBadge(int cantidad) {
    Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false)
        .cantidadNotificacion = cantidad;
  }

  int getCantidadNotificaciones() {
    int cantidad =  Provider.of<NotificationInfo>(navigatorKey.currentContext, listen: false).cantidadNotificacion;
    return cantidad;
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

  Future<bool> modelChangeBuzon(
      String nameBuzon, bool isCliente, bool barrier) async {
    bool respuesta = await showAnimatedDialog(
        barrierDismissible: barrier,
        context: navigatorKey.currentState.overlay.context,
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            title: Container(),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: StylesThemeData.PRIMARY_COLOR,
                      ),
                      child: AvatarGlow(
                        glowColor: Colors.white,
                        endRadius: 90.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              obtenerInicialesOfString(nameBuzon),
                              style: TextStyle(
                                  fontSize: 40,
                                  color: StylesThemeData.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold),
                            ),
                            radius: 50.0,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          nameBuzon,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          isCliente
                              ? 'El buzón del usuario ha sido modificado'
                              : 'La UTD del usuario ha sido modificado',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: InkWell(
                            onTap: () => Navigator.pop(context, true),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                              decoration: BoxDecoration(
                                color: StylesThemeData.PRIMARY_COLOR,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Text(
                                'Aceptar',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ]),
          );
        });

    if (respuesta == null) {
      respuesta = true;
    }

    return respuesta;
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
        // ignore: missing_return
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

  Future<bool> informacionCargo(
      String titulo, CargoModel cargo, TrackingModel trackingModel) async {
    String rutaImagen = cargo.valor;
    String tipoCargo = cargo.tipoCargoModel.nombre;
    bool respuesta = await showDialog(
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
                        style: TextStyle(color: Colors.blue[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3.0, color: Colors.blue[200]),
                  ),
                )),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Tipo de cargo',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("$tipoCargo",
                            style:
                                TextStyle(color: StylesThemeData.LETTER_COLOR)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Código',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.codigo,
                            style:
                                TextStyle(color: StylesThemeData.LETTER_COLOR)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Destinatario',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.destinatario,
                            style:
                                TextStyle(color: StylesThemeData.LETTER_COLOR)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  alignment: Alignment.center,
                  child: RotationTransition(
                      turns: new AlwaysStoppedAnimation(90 / 360),
                      child: Container(
                          child: Image.network('$rutaImagen',
                              height: 150, width: 250)))),
              InkWell(
                onTap: () => Navigator.pop(context, true),
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
    if (respuesta == null || respuesta) {
      respuesta = true;
    }
    return respuesta;
  }
}
