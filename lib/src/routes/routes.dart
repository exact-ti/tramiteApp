import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Clasificacion-palomar/ClasificacionPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-regular/EntregaRegularPage.dart';
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



Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    '/principal-admin': (BuildContext context) => HomePage(),
    '/generar-envio': (BuildContext context) => PrincipalPage(),
    '/crear-envio': (BuildContext context) => EnvioPage(),
    '/recorridos': (BuildContext context) => ListarTurnosPage(),
    '/entregas-pisos-propios': (BuildContext context) => RecorridosPropiosPage(),
    '/entregas-pisos-adicionales': (BuildContext context) => RecorridosAdicionalesPage(),
    //'/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/paquete-externo':(BuildContext context) => PaqueteExternoPage(),
    '/paquete-externo-custodia': (BuildContext context) => CustodiaExternoPage(),
    '/entregas-pisos-validacion': (BuildContext context) => ValidacionEnvioPage(),
    '/entrega-regular': (BuildContext context) => EntregaRegularPage(),
    '/entrega-personalizada': (BuildContext context) => EntregapersonalizadoPage(),
    '/clasificar-envio' :  (BuildContext context) => ClasificacionPage(),
    
  };
}
