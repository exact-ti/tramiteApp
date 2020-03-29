import 'package:tramiteapp/src/ModelDto/RutaModelRecojo.dart';

import 'RutaModelEntrega.dart';
import 'RutaModelId.dart';

class RutaModel {

  RutaModelId id;
  String nombre;
  int orden;
  RutaModelEntrega rutaModelEntrega;
  RutaModelRecojo rutaModelRecojo;
  bool visitada;

    RutaModel({
        this.id,
        this.nombre = '',
        this.orden,
        this.rutaModelEntrega,
        this.rutaModelRecojo,
        this. visitada = true,
    });

    List<RutaModel> fromJson(List< dynamic> jsons){
       List<RutaModel> rutas= new List();
        for(Map<String, dynamic> json in jsons){
          RutaModel ruta = new RutaModel();
          RutaModelEntrega rutaentrega = new RutaModelEntrega();
          RutaModelId rutaId = new RutaModelId();
          RutaModelRecojo rutarecojo = new RutaModelRecojo();
          Map<String, dynamic> idmap = json["id"];
          Map<String, dynamic> recojomap = json["cantidadRecojo"];
          Map<String, dynamic> entregamap = json["cantidadEntrega"];
            rutaId.bandejaId = idmap["bandejaId"];
            rutaId.entregaPisosId = idmap["entregaPisosId"];
            ruta.nombre  = json["nombre"];
            ruta.orden = json["orden"];
            ruta.visitada = json["visitada"];
            rutarecojo.total = recojomap["total"];
            rutarecojo.procesados=recojomap["procesados"];
            rutaentrega.total = entregamap["total"];
            rutaentrega.procesados=entregamap["procesados"];
            ruta.id=rutaId;
            ruta.rutaModelRecojo=rutarecojo;
            ruta.rutaModelEntrega=rutaentrega;     
            rutas.add(ruta);
        }
          return rutas;
    }

}