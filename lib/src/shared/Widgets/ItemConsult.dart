import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class ItemsConsult extends StatelessWidget {
  final List<EnvioModel> enviosModel;

  const ItemsConsult({
    Key key,
    @required this.enviosModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget itemConsult(EnvioModel envioModel){
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text('De',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                            envioModel.remitente == null
                                ? "Envío importado"
                                : envioModel.remitente,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text('para',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(envioModel.destinatario,
                            style: TextStyle(color: Colors.black)),
                        flex: 5,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: new GestureDetector(
                              onTap: () {
                                trackingPopUp(context, envioModel.id);
                              },
                              child: Text(envioModel.codigoPaquete,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)),
                            )),
                        flex: 3,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 10),
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: Text(envioModel.codigoUbicacion,
                              style: TextStyle(color: Colors.black)),
                        ),
                        flex: 6,
                      ),
                    ],
                  )),
            ],
          ));
    }


    return enviosModel.isEmpty?Container():ListView.builder(
          itemCount: this.enviosModel.length,
          itemBuilder: (context, i) => itemConsult(this.enviosModel[i]));
  }
}
