import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/Util/utils.dart';

void trackingPopUp(BuildContext context, int codigo) async {
  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());
  double heightCel = 0.6 * (MediaQuery.of(context).size.height);
  String observacion = "";
  TrackingModel trackingModel = await trackingCore.mostrarTracking(codigo);

  List<Widget> listadecodigos = new List();
  List<TrackingDetalleModel> detalles = trackingModel.detalles;
  detalles.sort((a, b) => a.fecha.compareTo(b.fecha));
  for (TrackingDetalleModel detalle in trackingModel.detalles) {
    listadecodigos.add(Container(
        decoration: myBoxDecoration(colorletra),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                detalle.fecha,
                style: TextStyle(color: colorletra, fontSize: 12),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.remitente,
                  style: TextStyle(color: colorletra, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.sede,
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
          ],
        )));
  }

  if (trackingModel.observacion != null) {
    observacion = trackingModel.observacion;
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
          height: heightCel,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 10),
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
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('De',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.remitente,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Origen',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.origen,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Para',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.destinatario,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Destino',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(trackingModel.destino,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomLeft,
                          child: Text('Observación',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text(observacion,
                            style: TextStyle(color: colorletra)),
                        flex: 3,
                      ),
                    ],
                  )),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: listadecodigos))),
              /*Container(
             height: 20,   
            child:ListView(
              children:listadecodigos,
            )
              )*/
            ],
          ),
        ));
      });
}