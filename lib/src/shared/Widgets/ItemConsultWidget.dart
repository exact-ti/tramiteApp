import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/shared/modals/TrackingModal.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class ItemsConsultWidget extends StatelessWidget {
  final List<EnvioModel> enviosModel;

  const ItemsConsultWidget({
    Key key,
    @required this.enviosModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemConsult(EnvioModel envioModel) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LIST_BORDER_COLOR),
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
                          child: Text('De ',
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
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return TrackingModal(
                                        paqueteId: envioModel.id,
                                      );
                                    });
                              },
                              child: Text(envioModel.codigoPaquete,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15)),
                            )),
                        flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 10),
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: Text(envioModel.codigoUbicacion,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 3,
                      ),
                    ],
                  )),
            ],
          ));
    }

    return enviosModel.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: this.enviosModel.length,
            itemBuilder: (context, i) => itemConsult(this.enviosModel[i]));
  }
}
