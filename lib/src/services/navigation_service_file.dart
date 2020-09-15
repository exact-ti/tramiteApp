import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigationTo(String routeName) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  goBack() {
    navigatorKey.currentState.pop();
  }

  modelInformativo(String tipo, String titulo, String mensaje) {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey
            .currentState.overlay.context, // Using overlay's context
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
                  eliminarpreferences(null);
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
