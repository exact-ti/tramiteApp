import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/CargoModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';


Future<bool> informacionCargo(BuildContext context, String titulo,
    CargoModel cargo, TrackingModel trackingModel) async {
  String rutaImagen = cargo.valor;
  String tipoCargo = cargo.tipoCargoModel.nombre;
  bool respuesta = await showDialog(
      barrierDismissible: false,
      context: context,
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
                          style: TextStyle(color: StylesThemeData.LETTER_COLOR)),
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
                          style: TextStyle(color: StylesThemeData.LETTER_COLOR)),
                      flex: 3,
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, right: 20, left: 20),
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
                          style: TextStyle(color: StylesThemeData.LETTER_COLOR)),
                      flex: 3,
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only( right: 20, left: 20),
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
                          top: BorderSide(width: 3.0, color: Colors.grey[100]),
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
