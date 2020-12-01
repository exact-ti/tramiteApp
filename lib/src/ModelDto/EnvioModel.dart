import 'package:tramiteapp/src/Util/timezone.dart' as timezone;
import 'package:intl/intl.dart';

class EnvioModel {
  int id;
  int remitenteId;
  int destinatarioId;
  String codigoPaquete;
  String codigoUbicacion;
  String observacion;
  String usuario;
  String destinatario;
  String remitente;
  String fecha;
  bool estado;

  EnvioModel(
      {this.id,
      this.remitenteId,
      this.destinatarioId,
      this.codigoUbicacion = '',
      this.codigoPaquete = '',
      this.observacion = '',
      this.estado = false});

  List<EnvioModel> fromJsonValidar(List<dynamic> jsons) {
    List<EnvioModel> envios = [];
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.id = json["id"];
      envio.codigoPaquete = json["paqueteId"];
      envios.add(envio);
    }
    return envios;
  }

  List<EnvioModel> fromJsonValidarRecepcion(List<dynamic> jsons) {
    List<EnvioModel> envios = new List();
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.usuario = json["remitente"];
      envio.codigoPaquete = json["paqueteId"];
      envio.observacion = json["estado"];
      envio.id = json["id"];
      envios.add(envio);
    }
    return envios;
  }

  List<EnvioModel> fromJsonValidarToCustodiarAgencia(List<dynamic> jsons) {
    List<EnvioModel> envios = new List();
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.codigoPaquete = json["paqueteId"];
      envio.observacion = json["tipoPaquete"];
      envio.id = json["id"];
      envios.add(envio);
    }
    return envios;
  }


  List<EnvioModel> fromEnviadosActivos(List<dynamic> jsons) {
    List<EnvioModel> envios = new List();
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.remitente = json["remitente"];
      envio.destinatario = json["destinatario"];
      envio.codigoPaquete = json["paqueteId"];
      envio.observacion = json["estado"];
      dynamic dateTimeZone = timezone.parse(json["fechaCreado"]);
      envio.fecha = "$dateTimeZone";
      DateTime fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(envio.fecha);
      envio.fecha = DateFormat('dd-MM-yyyy hh:mm:ssa').format(fecha);
      envio.id = json["id"];
      envios.add(envio);
    }
    return envios;
  }

    List<EnvioModel> fromEnviosUTD(List<dynamic> jsons) {
    List<EnvioModel> envios = new List();
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.remitente = json["remitente"];
      envio.destinatario = json["destinatario"];
      envio.codigoPaquete = json["paqueteId"];
      envio.observacion = json["estado"];
      dynamic dateTimeZone = timezone.parse(json["fechaCreado"]);
      envio.fecha = "$dateTimeZone";
      DateTime fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(envio.fecha);
      envio.fecha = DateFormat('dd-MM-yyyy hh:mm:ssa').format(fecha);
      envio.id = json["id"];
      envios.add(envio);
    }
    return envios;
  }

  List<EnvioModel> fromJsonConsultaEnvio(List<dynamic> jsons) {
    List<EnvioModel> envios = new List();
    for (Map<String, dynamic> json in jsons) {
      EnvioModel envio = new EnvioModel();
      envio.id = json["id"];
      envio.codigoPaquete = json["paqueteId"];
      envio.destinatario = json["destinatario"];
      envio.remitente = json["remitente"];
      envio.codigoUbicacion = json["estado"];
      envios.add(envio);
    }
    return envios;
  }

  EnvioModel fromOneJson(dynamic json) {
    EnvioModel envio = new EnvioModel();
    envio.id = json["id"];
    envio.codigoPaquete = json["paqueteId"];
    return envio;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "remitenteId": remitenteId,
        "destinatarioId": destinatarioId,
        "codigoPaquete": codigoPaquete,
        "codigoUbicacion": codigoUbicacion,
        "observacion": observacion,
      };
}
