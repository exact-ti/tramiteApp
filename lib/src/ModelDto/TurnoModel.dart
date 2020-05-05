import 'package:intl/intl.dart';

class TurnoModel {
  
  int id;
  DateTime horaInicio;
  DateTime horaFin;

  List<TurnoModel> fromJson(List< dynamic> jsons){
       List<TurnoModel> turnos= new List();
        for(Map<String, dynamic> json in jsons){
          TurnoModel turno = new TurnoModel();
          
          turno.id = json["id"];
          turno.horaInicio = new DateFormat("HH:mm:ss").parse(json["horaInicio"]);
          turno.horaFin = new DateFormat("HH:mm:ss").parse(json["horaFin"]);
          turnos.add(turno);
        }
          return turnos;
    }
}