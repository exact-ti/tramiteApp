

import 'TurnoModel.dart';
import 'package:intl/intl.dart';

class TrackingDetalleModel {

  String fecha;
  String remitente;
  String sede;
  String area;

  TrackingDetalleModel({
        this.remitente='',
        this.sede='',
        this.area='',
    });


      TrackingDetalleModel fromJson(dynamic json){
       TrackingDetalleModel detalleModel= new TrackingDetalleModel();
          detalleModel.remitente = json["estado"];
          DateTime fecha = new DateFormat("yyyy-MM-dd'T'hh:mm:ss").parse(json["fecha"]);
          detalleModel.fecha= DateFormat('yyyy-MM-dd hh:mm:ssa').format(fecha);
          detalleModel.sede  = json["ubicacion"];
          return detalleModel;
    }
}