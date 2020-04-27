
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';

class TrackingModel {

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

  TrackingModel fromOneJsonTracking(dynamic json){
            TrackingModel  trackingModel = new TrackingModel();  
            List<TrackingDetalleModel> detalleTracking =new List();
            trackingModel.remitente  = json["remitente"];
            trackingModel.origen  = json["origen"];
            trackingModel.destinatario  = json["destinatario"];
            trackingModel.destino  = json["destino"];
            trackingModel.area  = json["area"];
            trackingModel.observacion  = json["observacion"];
            List<dynamic> detallesHashMap = json["detalles"];
            for(Map<String, dynamic> json in detallesHashMap){
                TrackingDetalleModel  detalle = new TrackingDetalleModel();
                detalle.fecha  = json["fecha"];
                detalle.remitente = json["remitente"];
                detalle.sede  = json["sede"];
                detalle.area = json["area"];                
                detalleTracking.add(detalle);
            }            
            trackingModel.detalles=detalleTracking;
          return trackingModel;
    }   
}