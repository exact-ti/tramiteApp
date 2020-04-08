import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/Providers/rutas/IRutaProvider.dart';
import 'package:tramiteapp/src/Providers/rutas/impl/RutaProvider.dart';

import 'RutaInterface.dart';



class RutaImpl implements RutaInterface {
  
  IRutaProvider ruta;

  RutaImpl(RutaProvider rutaProvider){
    this.ruta = rutaProvider;
  }

  @override
  Future<List<RutaModel>> listarMiruta(int recorridoId) async {
     List<RutaModel> rutaModel = await ruta.listarMiRuta(recorridoId) ;
      return rutaModel;
  }

  @override
  Future<bool> opcionRecorrido(RecorridoModel recorrido) async{
      bool respuesta;
      if(recorrido.indicepagina==1){
       respuesta = await ruta.iniciarRecorrido(recorrido.id) ;
      }else{
       respuesta = await ruta.terminarRecorrido(recorrido.id) ;
      }
      
      return respuesta;
  }

  


}
