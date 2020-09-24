import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Clasificacion-palomar/ClasificacionPage.dart';
import 'package:tramiteapp/src/Vistas/Consulta-Envio/ConsultaEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Listar-envios/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nueva-intersede/EntregaInterPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Listar-TipoPersonalizada/ListarTipoPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-UTD/ListarEnviosUTDPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-activos/Listar-envios/ListarEnviosActivosPage.dart';
import 'package:tramiteapp/src/Vistas/Envio-agencias-externas/Listar-envios-agencias/ListarEnviosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/Listar-turnos/ListarTurnosPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-adicionales/recorridoAdicionalPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-propios/recorridoPropioPage.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/Historicos/HistoricoPage.dart';
import 'package:tramiteapp/src/Vistas/Home/HomePage.dart';
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoPage.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoPage.dart';
import 'package:tramiteapp/src/Vistas/Retirar-Envio/RetirarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/dashboard/dashboardPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/MenuDrawerPage.dart';
import 'package:tramiteapp/src/Vistas/recepcion/RecepcionEnvio.dart';




Map<String, WidgetBuilder> getAplicationRoutes() {

  return <String, WidgetBuilder>{

    //==================Login====================================

    '/login': (BuildContext context) => LoginPage(),

    //==================Menu principal====================================
    '/home': (BuildContext context) => HomePage(),
    '/generar-envio': (BuildContext context) => PrincipalPage(),
    '/recorridos': (BuildContext context) => ListarTurnosPage(),
    '/clasificar-envio' :  (BuildContext context) => ClasificacionPage(),
    '/envio-interutd' :  (BuildContext context) => ListarEnviosPage(),
    '/envio-lote' :  (BuildContext context) => ListaEntregaLotePage(),
    '/envios-agencia' :  (BuildContext context) => ListarEnviosAgenciasPage (),
    '/confirmar-envios' :  (BuildContext context) => RecepcionEnvioPage(),
    '/consulta-envios' :  (BuildContext context) => ConsultaEnvioPage(),
    '/envios-activos' :  (BuildContext context) => ListarEnviosActivosPage(),
    '/recepcionar-valija' :  (BuildContext context) => RecepcionInterPage(recorridopage: null),
    '/recepcionar-lote' :  (BuildContext context) => RecepcionEntregaLotePage(entregaLotepage:null),
    '/dashboard' :  (BuildContext context) => DashboardPage(),
    '/envios-en-utd' :  (BuildContext context) => ListarEnviosUTDPage(),
    '/envios-historicos' :  (BuildContext context) => HistoricoPage(),
    '/retirar-envio' :  (BuildContext context) => RetirarEnvioPage(),
    //==================Menu secundario====================================
    '/crear-envio': (BuildContext context) => EnvioPage(),
    '/entregas-pisos-propios': (BuildContext context) => RecorridosPropiosPage(),
    '/entregas-pisos-adicionales': (BuildContext context) => RecorridosAdicionalesPage(),
    '/paquete-externo':(BuildContext context) => PaqueteExternoPage(),
    '/custodia': (BuildContext context) => CustodiaExternoPage(),
    '/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/entrega-regular': (BuildContext context) => EntregaRegularPage(),
    '/entrega-personalizada': (BuildContext context) => ListarTipoPersonalizadaPage(),
    '/nueva-entrega-intersede' :  (BuildContext context) => NuevoIntersedePage(),
    '/notificaciones' :  (BuildContext context) => NotificacionesPage(),
    '/menuDrawer' :  (BuildContext context) => MenuDrawerPage(),

    
  };
}
