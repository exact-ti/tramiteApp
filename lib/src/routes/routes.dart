import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Clasificacion-palomar/ClasificacionPage.dart';
import 'package:tramiteapp/src/Vistas/Consulta-Envio/ConsultaEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Listar-envios/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nueva-intersede/EntregaInterPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/Listar-envios/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-agencias-externas/Listar-envios-agencias/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Listar-turnos/ListarTurnosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-adicionales/recorridoAdicionalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-propios/recorridoPropioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoPage.dart';
import 'package:tramiteapp/src/Vistas/prueba/firma.dart';
import 'package:tramiteapp/src/Vistas/prueba/showfirma.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';




Map<String, WidgetBuilder> getAplicationRoutes() {

  return <String, WidgetBuilder>{

    //==================Login====================================

    '/login': (BuildContext context) => LoginPage(),

    //==================Menu principal====================================
    '/principal-admin': (BuildContext context) => MyHomePage(),
    '/generar-envio': (BuildContext context) => ShowFirmaPage(),
    '/recorridos': (BuildContext context) => ListarTurnosPage(),
    '/clasificar-envio' :  (BuildContext context) => ClasificacionPage(),
    '/envio-intersede' :  (BuildContext context) => ListarEnviosPage(),
    '/envio-lote' :  (BuildContext context) => ListaEntregaLotePage(),
    '/envios-agencia' :  (BuildContext context) => ListarEnviosAgenciasPage (),
    '/recepcion' :  (BuildContext context) => RecepcionEnvioPage(),
    '/consulta-envio' :  (BuildContext context) => ConsultaEnvioPage(),
    '/envios-activos' :  (BuildContext context) => ListarEnviosActivosPage(),
    '/recepcionar-valija' :  (BuildContext context) => RecepcionInterPage(recorridopage: null),
    '/recepcionar-lote' :  (BuildContext context) => RecepcionEntregaLotePage(entregaLotepage:null),


    //==================Menu secundario====================================

    '/crear-envio': (BuildContext context) => EnvioPage(),
    '/entregas-pisos-propios': (BuildContext context) => RecorridosPropiosPage(),
    '/entregas-pisos-adicionales': (BuildContext context) => RecorridosAdicionalesPage(),
    '/paquete-externo':(BuildContext context) => PaqueteExternoPage(),
    '/paquete-externo-custodia': (BuildContext context) => CustodiaExternoPage(),
    '/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/entrega-regular': (BuildContext context) => EntregaRegularPage(),
    '/entrega-personalizada': (BuildContext context) => EntregapersonalizadoPage(),
    '/nueva-entrega-intersede' :  (BuildContext context) => NuevoIntersedePage(),
  };
}
