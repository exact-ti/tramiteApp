import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/impl/RecepcionProvider.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Generar-ruta/GenerarRutaPage.dart';

class RecepcionControllerLote {

  RecepcionInterface recepcionInterface = new RecepcionImpl(new RecepcionProvider());

  Widget labeltext(String mensaje){
  return Container(
    child: Text("$mensaje"),
    margin: const EdgeInsets.only(left: 15),
  );
  }

  Future<List<EnvioModel>> listarEnviosLotes(
      BuildContext context,  String codigo) async {
        if(codigo==""){
            return null;
        }
    List<EnvioModel> recorridos =
        await recepcionInterface.enviosCore(codigo);
    return recorridos;
  }

   Future<List<EnvioModel>> listarEnviosPrincipal(
      BuildContext context,List<String> codigos, String codigo) async {
    
        if(codigo==""){
              List<EnvioModel> envios = await recepcionInterface.listarEnviosPrincipalCore();
              return envios;
        }else{
              bool respuesta = await recepcionInterface.registrarEnvioPrincipalCore(codigo);
            if(codigos.contains(codigo)){
              if(!respuesta){
                notificacion(
              context, "error", "EXACT", "No se pudo registrar el documento");
              }
              List<EnvioModel> envios = await recepcionInterface.listarEnviosPrincipalCore();
              return envios;
            }else{
              if(!respuesta){
                notificacion(
              context, "error", "EXACT", "No es posible procesar el código");
              }else{
                notificacion(context, "success", "EXACT", "Registro correcto");
              }
              List<EnvioModel> envios = await recepcionInterface.listarEnviosPrincipalCore();
              return envios;
            }
        }
  }

    Future<List<EnvioModel>> listarEnvios(
      BuildContext context) async {
    List<EnvioModel> recorridos =
        await recepcionInterface.listarEnviosCore();
    if (recorridos.isEmpty) {
       notificacion(
              context, "error", "EXACT", "No hay envíos para recoger");
    }
    return recorridos;
  }

  Future<bool> recogerdocumentoLote(BuildContext context, String codigo,
      String paquete) async {
    bool respuesta =await recepcionInterface.recibirLote(codigo, paquete);
    return respuesta;
  }


    Future<bool> recogerdocumento(BuildContext context, String codigo) async {
    bool respuesta = await recepcionInterface.registrarEnvioCore(codigo);
      return respuesta;
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }

Widget contenidoPopUp(Color color, List<EnvioModel> novalidados, int cantidad){
    
    List<Widget> listadecodigos = new List();
    for (EnvioModel envio in novalidados) {
      String codigo = envio.codigoPaquete;
      listadecodigos.add(Text('$codigo'));
    }

      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
              child: ListBody(children: listadecodigos),
      ));


}
    Future<bool> guardarLista(
      BuildContext context, List<String> lista) async {
            bool respuesta = await recepcionInterface.registrarListaEnvioPrincipalCore(lista);
      return respuesta;
  }

}
