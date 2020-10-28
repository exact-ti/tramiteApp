import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> confirmacion(
    BuildContext context, String tipo, String title, String description) async {
  bool respuesta = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          title: Container(
              alignment: Alignment.centerLeft,
              height: 60.00,
              width: double.infinity,
              child: Container(
                  child: Text('$title',
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
              child: Text(description),
              padding: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 20, top: 20),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
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
                                    width: 1.5, color: Colors.grey[100])
                              ),
                            ),
                            child: Container(
                              child: Text('Aceptar',
                                  style: TextStyle(color: Colors.black)),
                            ))),
                  ),
                  flex: 5,
                ),
                Expanded(
                    flex: 5,
                    child: InkWell(
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
                                    width: 1.5, color: Colors.grey[100])
                                ),
                              ),
                              child: Container(
                                child: Text('Cancelar',
                                    style: TextStyle(color: Colors.black)),
                              ))),
                    ))
              ],
            )
          ]),
          contentPadding: EdgeInsets.all(0),
        );
      });

  return respuesta;
}
