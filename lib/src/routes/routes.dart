import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Clasificacion-palomar/ClasificacionPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Listar-envios/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nueva-intersede/EntregaInterPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/Listar-envios/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-agencias-externas/Listar-envios-agencias/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/Listar-turnos/ListarTurnosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/recorridos-adicionales/recorridoAdicionalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/recorridos-propios/recorridoPropioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-entrega/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionJumboPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionValijaPage.dart';



Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    '/principal-admin': (BuildContext context) => HomePage(),
    '/generar-envio': (BuildContext context) => PrincipalPage(),
    '/crear-envio': (BuildContext context) => EnvioPage(),
    //'/recorridos': (BuildContext context) => ListarTurnosPage(),
    '/recorridos': (BuildContext context) => ListarEnviosActivosPage(),
    '/entregas-pisos-propios': (BuildContext context) => RecorridosPropiosPage(),
    '/entregas-pisos-adicionales': (BuildContext context) => RecorridosAdicionalesPage(),
    //'/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/paquete-externo':(BuildContext context) => PaqueteExternoPage(),
    '/paquete-externo-custodia': (BuildContext context) => CustodiaExternoPage(),
    '/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/entrega-regular': (BuildContext context) => EntregaRegularPage(),
    '/entrega-personalizada': (BuildContext context) => EntregapersonalizadoPage(),
    '/clasificar-envio' :  (BuildContext context) => ClasificacionPage(),
    '/entrega-lotes' :  (BuildContext context) => ListaEntregaLotePage(),
    
    '/entrega-intersede' :  (BuildContext context) => ListarEnviosPage(),
    '/recepcionar-jumbo' :  (BuildContext context) => RecepcionJumboPage(),
    '/recepcionar-valija' :  (BuildContext context) => RecepcionValijaPage(),
    '/envios-agencia' :  (BuildContext context) => ListarEnviosAgenciasPage(),
    '/nueva-entrega-intersede' :  (BuildContext context) => NuevoIntersedePage(),
    '/recepcion-inter' :  (BuildContext context) => RecepcionEnvioPage(),
  };
}
