import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Recepcion/RecepcionInterface.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/Providers/recepciones/impl/RecepcionProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Generar-ruta/GenerarRutaPage.dart';

class RecepcionController {

  RecepcionInterface recepcionInterface = new RecepcionImpl(new RecepcionProvider());

  Widget labeltext(String mensaje){
  return Container(
    child: Text("$mensaje"),
    margin: const EdgeInsets.only(left: 15),
  );
  }

  Future<List<EnvioModel>> listarEnviosLotes(
      BuildContext context,  String codigo, bool opcion) async {
    List<EnvioModel> recorridos =
        await recepcionInterface.enviosCore(codigo, opcion);
    if (recorridos.isEmpty) {
      mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
    }
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
                mostrarAlerta(context,"No se pudo registrar el documento", "registro incorrecto");
              }
              List<EnvioModel> envios = await recepcionInterface.listarEnviosCore();
              return envios;
            }else{
              if(!respuesta){
                mostrarAlerta(context,"El documento no pertenece a este envío", "registro incorrecto");
              }else{
                mostrarAlerta(context,"Registro correcto", "Mensaje");
              }
              List<EnvioModel> envios = await recepcionInterface.listarEnviosCore();
              return envios;
            }
        }
  }

    Future<List<EnvioModel>> listarEnvios(
      BuildContext context) async {
    List<EnvioModel> recorridos =
        await recepcionInterface.listarEnviosCore();
    if (recorridos.isEmpty) {
      mostrarAlerta(context, "No hay envíos para recoger", "Mensaje");
    }
    return recorridos;
  }

  void recogerdocumentoLote(BuildContext context, String codigo,
      String paquete, bool opcion) async {
    bool respuesta =
        await recepcionInterface.registrarRecorridoCore(codigo, paquete, opcion);
    if (respuesta == false) {
      mostrarAlerta(
          context, "No se pudo completar la operación", "Código incorrecto");
    }
  }


    void recogerdocumento(BuildContext context, String codigo) async {
    bool respuesta =
        await recepcionInterface.registrarEnvioCore(codigo);
    if (respuesta == false) {
      mostrarAlerta(
          context, "No se pudo completar la operación", "Código incorrecto");
    }
  }

  void redirectMiRuta(RecorridoModel recorrido, BuildContext context) async {
    recorrido.indicepagina = 2;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarRutaPage(recorridopage: recorrido),
        ));
  }

Widget contenidoPopUp(Color color,String destino, int cantidad){

      return Container(
        decoration: myBoxDecoration(color),
        margin: EdgeInsets.only(bottom: 5),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  height: 100,
                  padding: const EdgeInsets.only(right: 26, bottom: 30),
                  child: Center(
                    child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.cube,
                      color: Color(0xff000000),
                      size: 60,
                    ), onPressed: () {},
                  )))),
          Expanded(
            child: Text("$destino",style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black),),
            flex: 1,
          ),
          Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        child: Text("$cantidad documentos pendientes"))
                  ])),
        ]),
      );


}
  
}
