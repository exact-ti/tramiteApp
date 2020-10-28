
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';

class TrackingModel {

  int id;
  String codigo;
  String remitente;
  String origen;
  String destinatario;
  String destino;
  String area;
  String observacion;
  List<TrackingDetalleModel> detalles;

    TrackingModel({
        this.codigo,
        this.remitente,
        this.origen,
        this.destinatario='',
        this.destino='',
        this.observacion='',
    });

  TrackingModel fromOneJsonTracking(dynamic json,List< dynamic> json2){
            TrackingModel  trackingModel = new TrackingModel();  
            List<TrackingDetalleModel> detalleTracking =new List();
            trackingModel.id  = json["id"];
            trackingModel.remitente  = json["remitente"];
            trackingModel.origen  = json["origen"];
            trackingModel.destinatario  = json["destinatario"];
            trackingModel.destino  = json["destino"];
            trackingModel.observacion  = json["observacion"];
            trackingModel.codigo = json["paqueteId"];
            for(Map<String, dynamic> json in json2 ){
                TrackingDetalleModel  detalle = new TrackingDetalleModel();
                detalle = detalle.fromJson(json);
                detalleTracking.add(detalle);
            }            
            trackingModel.detalles=detalleTracking;
          return trackingModel;
    }   
}

class DateFormat {
}