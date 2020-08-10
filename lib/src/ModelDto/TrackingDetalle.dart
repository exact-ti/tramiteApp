

import 'package:intl/intl.dart';
import 'package:tramiteapp/src/ModelDto/CargoModel.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;

class TrackingDetalleModel {

  String fecha;
  String estado;
  String ubicacion;
  String area;
  CargoModel cargo;

      TrackingDetalleModel fromJson(dynamic json){
       TrackingDetalleModel detalleModel= new TrackingDetalleModel();
       CargoModel cargoModel = new CargoModel();
          detalleModel.estado = json["estado"];
          dynamic dateTimeZone = timezone.parse(json["fecha"]);
          detalleModel.fecha="$dateTimeZone";
          DateTime fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(detalleModel.fecha);
          detalleModel.fecha= DateFormat('yyyy-MM-dd hh:mm:ssa').format(fecha);
          detalleModel.ubicacion  = json["ubicacion"];
          detalleModel.cargo =cargoModel.fromOneJsonCargo(json["cargo"]);
          return detalleModel;
    }
}