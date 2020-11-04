import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Enumerator/EstadoEnvioEnum.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLoteController.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Nueva-entrega-lote/NuevaEntregaLotePage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Recepcionar-lote/RecepcionEntregaLote.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class ListaEntregaLotePage extends StatefulWidget {
  @override
  _ListaEntregaLotePageState createState() => new _ListaEntregaLotePageState();
}

class _ListaEntregaLotePageState extends State<ListaEntregaLotePage> {
  ListaEntregaLoteController listarLoteController = new ListaEntregaLoteController();
  List<bool> isSelected;
  int modalidadTipoId = 0;
  List<EntregaLoteModel> entregas = new List();

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  void onPressedRecepcionarButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionEntregaLotePage(entregaLotepage: null),
        ));
  }

  void onPressedNuevoButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoEntregaLotePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(EntregaLoteModel entrega, int switched) {
      String codigo = "";
      if (switched != 0) {
        codigo = entrega.paqueteId;
      }
      return Container(
          height: 70,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 35,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("${entrega.udtNombre}",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: switched == 0
                              ? Container()
                              : Text("$codigo", style: TextStyle(fontSize: 10)),
                        ),
                      ]),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    height: 35,
                    child: switched == 0
                        ? Text(
                            entrega.cantLotes == 1
                                ? "${entrega.cantLotes} Lote"
                                : "${entrega.cantLotes} Lotes",
                            style: TextStyle(fontSize: 12))
                        : Text(
                            entrega.cantLotes == 1
                                ? "${entrega.cantLotes} valija"
                                : "${entrega.cantLotes} valijas",
                            style: TextStyle(fontSize: 12))),
              ]));
    }

    Widget iconoRecepcion(EntregaLoteModel entregaLote, BuildContext context) {
      return Container(
          height: 70,
          child: Center(
              child: FaIcon(
            FontAwesomeIcons.locationArrow,
            color: StylesThemeData.ICON_COLOR,
            size: 25,
          )));
    }

    void iniciarEnvioLote(EntregaLoteModel entrega) async {
      bool respuesta = await listarLoteController.onSearchButtonPressed(context, entrega);
      if (respuesta) {
        notificacion(context, "success", "EXACT",
            "Se ha iniciado el envío correctamente");
        setState(() {
          modalidadTipoId = modalidadTipoId;
        });
      } else {
        notificacion(
            context, "error", "EXACT", "No se pudo iniciar la entrega");
      }
    }

    Widget iconoEnvio(EntregaLoteModel entrega) {
      return Container(
          height: 70,
          child: entrega.estadoEnvio.id == creado
              ? Center(
                  child: FaIcon(
                  FontAwesomeIcons.locationArrow,
                  color: StylesThemeData.ICON_COLOR,
                  size: 25,
                ))
              : Opacity(
                  opacity: 0.0,
                  child: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: StylesThemeData.ICON_COLOR,
                    size: 25,
                  )));
    }

    Widget crearItem(EntregaLoteModel entrega, int switched) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTER_COLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () {
                if (switched == 0) {
                  iniciarEnvioLote(entrega);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecepcionEntregaLotePage(entregaLotepage: entrega),
                      ));
                }
              },
              child: Container(
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                          height: 70,
                          child: Center(
                              child: FaIcon(
                            FontAwesomeIcons.cube,
                            color: Color(0xff000000),
                            size: 40,
                          )))),
                  Expanded(
                    child: informacionEntrega(entrega, switched),
                    flex: 3,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            switched == 0
                                ? iconoEnvio(entrega)
                                : iconoRecepcion(entrega, context)
                          ])),
                ]),
              )));
    }

    Widget _crearListado(int switched) {
      return FutureBuilder(
          future: listarEntregas(switched),
          builder: (BuildContext context,
              AsyncSnapshot<List<EntregaLoteModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor",IconsData.ICON_ERROR_SERVIDOR);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados("Ha surgido un problema",IconsData.ICON_ERROR_PROBLEM);
                } else {
                  if (snapshot.hasData) {
                    entregas = snapshot.data;
                    if (entregas.length == 0) {
                      return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: entregas.length,
                          itemBuilder: (context, i) =>
                              crearItem(entregas[i], switched));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    Widget filaBotones = Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: ButtonWidget(
                  onPressed: onPressedNuevoButton,
                  colorParam: StylesThemeData.PRIMARY_COLOR,
                  texto: 'Nuevo')),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child:ButtonWidget(
                onPressed: onPressedRecepcionarButton,
                colorParam: StylesThemeData.DISABLE_COLOR,
                texto: 'Recepcionar')),
            flex: 5,
          )
        ],
      ),
    );

    final tabs = ToggleButtons(
      borderColor:  StylesThemeData.LETTER_COLOR,
      fillColor: StylesThemeData.LETTER_COLOR,
      borderWidth: 1,
      selectedBorderColor: StylesThemeData.LETTER_COLOR,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Enviados',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Por recibir',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
          modalidadTipoId = index;
        });
      },
      isSelected: isSelected,
    );

    return Scaffold(
      appBar: CustomAppBar(text: 'Entregas de Lotes'),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                width: double.infinity,
                child: filaBotones),
            Container(child: tabs),
            Expanded(
              child: Container(
                  decoration: myBoxDecoration(StylesThemeData.LETTER_COLOR),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: _crearListado(modalidadTipoId)),
            )
          ],
        ),
      ),
    );
  }

  Future<List<EntregaLoteModel>> listarEntregas(int modalidadId) async {
    if (modalidadId == 0) {
      return await listarLoteController.listarLotesActivos();
    } else {
      return await listarLoteController.listarLotesPorRecibir();
    }
  }
}
