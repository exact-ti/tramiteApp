import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Recepcion-intersede/RecepcionRegularPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TabSectionWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'ListarEnviosController.dart';

class ListarEnviosPage extends StatefulWidget {
  @override
  _ListarEnviosPageState createState() => _ListarEnviosPageState();
}

class _ListarEnviosPageState extends State<ListarEnviosPage> {
  ListarEnviosController listarEnviosController = new ListarEnviosController();
  List<EnvioInterSedeModel> listEnviosPorRecibir;
  List<EnvioInterSedeModel> listEnviosEnviados;
  bool porRecibir = true;
  List<bool> isSelected;
  int indexSwitch = 0;

  @override
  void initState() {
    isSelected = [true, false];
    listarEnviosIntersedes();
    super.initState();
  }

  void listarEnviosIntersedes() async {
    listEnviosPorRecibir = await listarEnviosController
        .listarentregasInterSedeController(porRecibir);
    listEnviosEnviados = await listarEnviosController
        .listarentregasInterSedeController(!porRecibir);
    if (this.mounted) {
      setState(() {
        listEnviosPorRecibir = listEnviosPorRecibir;
        listEnviosEnviados = listEnviosEnviados;
      });
    }
  }

  void iniciarEnvio(dynamic intersedeIndice) async {
    if (listEnviosEnviados[intersedeIndice].estadoEnvio.id == creado) {
      bool respuesta = await listarEnviosController.onSearchButtonPressed(
          context, listEnviosEnviados[intersedeIndice]);
      if (respuesta) {
        notificacion(context, "success", "EXACT",
            "Se ha iniciado el envío correctamente");
        listarEnviosIntersedes();
      } else {
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }
  }

  String obtenerTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].destino;
  }

  String obtenerSubTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].codigo;
  }

  String obtenerSecondSubTituloInRecepciones(dynamic intersedeIndice) {
    return listEnviosPorRecibir[intersedeIndice].numdocumentos == 1
        ? "${listEnviosPorRecibir[intersedeIndice].numdocumentos} envío"
        : "${listEnviosPorRecibir[intersedeIndice].numdocumentos} envíos";
  }

  String obtenerTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].destino;
  }

  String obtenerSubTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].numvalijas == 1
        ? "${listEnviosEnviados[intersedeIndice].numvalijas} valija"
        : "${listEnviosEnviados[intersedeIndice].numvalijas} valijas";
  }

  String obtenerSecondSubTituloInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].numdocumentos == 1
        ? "${listEnviosEnviados[intersedeIndice].numdocumentos} envío"
        : "${listEnviosEnviados[intersedeIndice].numdocumentos} envíos";
  }

  void actionButtonNuevo() {
    Navigator.of(context).pushNamed('/nueva-entrega-intersede');
  }

  void actionButtonRecepcionar() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionInterPage(recorridopage: null),
        )).whenComplete(listarEnviosIntersedes);
  }

  void recepcionarEnvio(dynamic intersedeIndice) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionInterPage(
              recorridopage: listEnviosPorRecibir[intersedeIndice]),
        )).whenComplete(listarEnviosIntersedes);
  }

  IconData obtenerIconInRecepciones(dynamic intersedeIndice) {
    return FontAwesomeIcons.locationArrow;
  }

  IconData obtenerIconInEnviados(dynamic intersedeIndice) {
    return listEnviosEnviados[intersedeIndice].estadoEnvio.id == creado
        ? FontAwesomeIcons.locationArrow
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Widget filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: ButtonWidget(
                  onPressed: actionButtonNuevo,
                  colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                  texto: "Nuevo")),
          Expanded(
              flex: 5,
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: ButtonWidget(
                      onPressed: actionButtonRecepcionar,
                      colorParam: StylesThemeData.BUTTON_SECUNDARY_COLOR,
                      texto: "Recepcionar"))),
        ],
      ),
    );
    return Scaffold(
        appBar: CustomAppBar(text: "Entregas interUTD"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[filaBotones],
                      )),
                  Expanded(
                      child: TabSectionWidget(
                    iconPrimerTap: Icons.call_received,
                    iconSecondTap: Icons.screen_share,
                    namePrimerTap: "Por recibir",
                    nameSecondTap: "Enviados",
                    listPrimerTap: listEnviosPorRecibir,
                    listSecondTap: listEnviosEnviados,
                    methodPrimerTap: recepcionarEnvio,
                    methodSecondTap: iniciarEnvio,
                    primerIconWiget: FontAwesomeIcons.cube,
                    obtenerSecondIconWigetInPrimerTap: obtenerIconInRecepciones,
                    obtenerSecondIconWigetInSecondTap: obtenerIconInEnviados,
                    obtenerTituloInPrimerTap: obtenerTituloInRecepciones,
                    obtenerSubTituloInPrimerTap: obtenerSubTituloInRecepciones,
                    obtenerSubSecondtituloInPrimerTap:
                        obtenerSecondSubTituloInRecepciones,
                    obtenerTituloInSecondTap: obtenerTituloInEnviados,
                    obtenerSubTituloInSecondTap: obtenerSubTituloInEnviados,
                    obtenerSubSecondtituloInSecondTap:
                        obtenerSecondSubTituloInEnviados,
                    styleTitulo:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    styleSubTitulo: TextStyle(fontSize: 10),
                    styleSubSecondtitulo: TextStyle(fontSize: 10),
                    iconWidgetColor: StylesThemeData.ICON_COLOR,
                  ))
                ],
              ),
            ),
            context));
  }
}
