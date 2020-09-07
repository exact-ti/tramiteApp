import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

Future<bool> confirmarArray(BuildContext context, String tipo, String titulo,
    String descripcion, List<EnvioModel> novalidados) async {
  List<Widget> listadecodigos = new List();

  for (EnvioModel codigo in novalidados) {
    String codigoPa = codigo.codigoPaquete;
    listadecodigos.add(Text('$codigoPa'));
  }

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
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: Column(children: <Widget>[
                  Container(
                      child: Text(descripcion),
                      margin: const EdgeInsets.only(bottom: 10)),
                  ListBody(children: listadecodigos)
                ]),
                padding: const EdgeInsets.all(20),
              ),
              InkWell(
                  onTap: () => Navigator.pop(context, true),
                  child: Center(
                      child: Container(
                          height: 50.00,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 3.0, color: Colors.grey[100]),
                                right: BorderSide(
                                    width: 1.5, color: Colors.grey[100])),
                          ),
                          child: Container(
                            child: Text('Registrar de todos modos',
                                style: TextStyle(color: Colors.black)),
                          ))),
                ), InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Center(
                        child: Container(
                            height: 50.00,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 3.0, color: Colors.grey[100]),
                                  left: BorderSide(
                                      width: 1.5, color: Colors.grey[100])),
                            ),
                            child: Container(
                              child: Text('Seguir validando',
                                  style: TextStyle(color: Colors.black)),
                            ))),
                  )
            ]),
          ),
          contentPadding: EdgeInsets.all(0),
        );
      });
  return respuesta;
}
