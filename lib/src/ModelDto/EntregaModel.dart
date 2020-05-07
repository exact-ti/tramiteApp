import 'EntregaEstadoModel.dart';

class EntregaModel {
  int id;
  EntregaEstadoModel estado;
  String usuario;
  String nombreTurno;

    EntregaModel({
        this.id,
        this.usuario = '',
        this.nombreTurno = '',
    });

    List<EntregaModel> fromJson(List< dynamic> jsons){
       List<EntregaModel> entregas= new List();
        for(Map<String, dynamic> json in jsons){
           EntregaModel men = new EntregaModel();
           EntregaEstadoModel estadoModel = new EntregaEstadoModel();
            men.id  = json["id"];
            Map<String, dynamic> estadoMap = json["estado"];
            estadoModel.id = estadoMap["id"];
            estadoModel.nombreEstado =  estadoMap["nombre"];
            men.usuario = json["usuario"];
            men.nombreTurno = json["nombreTurno"];
            men.estado=estadoModel;
            entregas.add(men);
        }
          return entregas;
    }

}