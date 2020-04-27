import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class ReusableWidgets {

  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());


  static getAppBar(String title) {
    return AppBar(
          backgroundColor: primaryColor,
          title: Text('$title',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
    );
  }

  void trackingPopUp(BuildContext context, String codigo) async {

    TrackingModel trackingModel = await trackingCore.mostrarTracking(codigo);

    List<Widget> listadecodigos = new List();

    for (TrackingDetalleModel detalle in trackingModel.detalles) {
      listadecodigos.add(Container(
        height: 50,
        child:Column(
          children: <Widget>[
            Text(detalle.fecha),
            Text("Creado por "+detalle.remitente),
            Text(detalle.area+" - "+detalle.sede),
          ],
        )
      ));
    }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
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
                      child:Text('Código', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.codigo,
                        style: TextStyle(color: Colors.blue)),
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
                      child:Text('De', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.remitente,
                        style: TextStyle(color: Colors.blue)),
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
                      child:Text('Origen', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.origen,
                        style: TextStyle(color: Colors.blue)),
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
                      child:Text('Para', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.destinatario,
                        style: TextStyle(color: Colors.blue)),
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
                      child:Text('Destino', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.area+" - "+trackingModel.destino,
                        style: TextStyle(color: Colors.blue)),
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
                      child:Text('Observación', style: TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(trackingModel.observacion,
                        style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              )),
              Container(
             height: 80,   
            child:ListView(
              children:listadecodigos,
            )
              )

            ],
          ),
          )
          

        );
      });
}



}