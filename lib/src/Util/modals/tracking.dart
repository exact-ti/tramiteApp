import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/CargoModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/Util/modals/trackingCargo.dart';
import 'package:tramiteapp/src/Util/utils.dart';

Widget cargoOrdni(
    BuildContext context, CargoModel cargo, TrackingModel trackingModel) {
  Widget repuesta;
  if (cargo != null) {
    switch (cargo.tipoCargoModel.id) {
      case 1:
        String cargodni = cargo.valor;
        repuesta = Container(
          child: Text("Recibido con código $cargodni",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12)),
          alignment: Alignment.centerLeft,
        );
        break;
      case 2:
        repuesta = InkWell(
            onTap: () {
              informacionCargo(context, "EXACT", cargo, trackingModel);
            },
            child: Container(
              child: Text("Cargo",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      decoration: TextDecoration.underline)),
              alignment: Alignment.centerRight,
            ));
        break;
      default:
        repuesta = Container();
    }
  } else {
    repuesta = Container();
  }

  return repuesta;
}

void trackingPopUp(BuildContext context, int codigo) async {
  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());
  double heightCel = 0.6 * (MediaQuery.of(context).size.height);
  String observacion = "";
  TrackingModel trackingModel = await trackingCore.mostrarTracking(codigo);
  List<Widget> listadecodigos = new List();
  List<TrackingDetalleModel> detalles = trackingModel.detalles;
  int tamlista = detalles.length;
  detalles.sort((a, b) => a.fecha.compareTo(b.fecha));
  bool bandera = true;
  int indicador = 1;
  for (TrackingDetalleModel detalle in trackingModel.detalles) {
    listadecodigos.add(Container(
        decoration: BoxDecoration(
            border: indicador != tamlista
                ? new Border(top: BorderSide(color: Colors.grey[200]))
                : new Border(
                    top: BorderSide(color: Colors.grey[200]),
                    bottom: BorderSide(color: Colors.grey[200])),
            color: bandera ? Color(0xFFDDEAF1) : Colors.white),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                detalle.fecha,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.estado,
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(detalle.ubicacion,
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              alignment: Alignment.centerLeft,
            ),
            Container(child: cargoOrdni(context, detalle.cargo, trackingModel))
          ],
        )));
    if (bandera) {
      bandera = false;
    } else {
      bandera = true;
    }
    indicador++;
  }

  if (trackingModel.observacion != null) {
    observacion = trackingModel.observacion;
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('EXACT',
                        style: TextStyle(color: Colors.blue[200])),
                    margin: const EdgeInsets.only(left: 20)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3.0, color: Colors.blue[200]),
                  ),
                )),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
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
                ],
              ),
            ));
      });
}
