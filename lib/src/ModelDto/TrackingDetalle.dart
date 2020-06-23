

import 'package:intl/intl.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;

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
          //DateTime fecha = new DateFormat("yyyy-MM-dd'T'hh:mm:ss").parse(json["fecha"]);
          //String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(fecha);
          dynamic dateTimeZone = timezone.parse(json["fecha"]);
          detalleModel.fecha="$dateTimeZone";
          DateTime fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(detalleModel.fecha);
          detalleModel.fecha= DateFormat('yyyy-MM-dd hh:mm:ssa').format(fecha);
          detalleModel.sede  = json["ubicacion"];
          return detalleModel;
    }
}