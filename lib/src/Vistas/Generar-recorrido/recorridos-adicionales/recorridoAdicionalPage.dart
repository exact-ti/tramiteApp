import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-adicionales/recorridoAdicionalController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

class RecorridosAdicionalesPage extends StatefulWidget {
  @override
  _RecorridosAdicionalesPageState createState() =>
      _RecorridosAdicionalesPageState();
}

class _RecorridosAdicionalesPageState extends State<RecorridosAdicionalesPage> {
  RecorridoAdicionalController principalcontroller =
      new RecorridoAdicionalController();
  String textdestinatario = "";
  final _destinatarioController = TextEditingController();
  FocusNode f1Destinatario = FocusNode();
  List<RecorridoModel> listasRecorridos = new List();

  @override
  void initState() {
    super.initState();
  }

  void onChanged(dynamic textForm) {
    setState(() {
      textdestinatario = textForm;
    });
  }

  void onPressRecorrido(dynamic indiceRecorrido) {
/*     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValidacionEnvioPage(
            recorridopage: listasRecorridos[indiceRecorrido]),
      ),
    ); */
    Navigator.of(context).pushNamed(
      '/entregas-pisos-validacion',
      arguments: {
        'recorridoId': listasRecorridos[indiceRecorrido].id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListadoporfiltro(String texto) {
      int cantidad = obtenerCantidadMinima();
      if (texto.length < cantidad)
        return sinResultados(
            "Ingrese el nombre del recorrido", IconsData.ICON_UP);
      return FutureBuilder(
          future: principalcontroller.recorridosController(texto),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor",
                    IconsData.ICON_ERROR_SERVIDOR);
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados(
                      "Ha surgido un problema", IconsData.ICON_ERROR_PROBLEM);
                } else {
                  if (snapshot.hasData) {
                    listasRecorridos = snapshot.data;
                    if (listasRecorridos.length == 0) {
                      return sinResultados("No se han encontrado resultados",
                          IconsData.ICON_ERROR_EMPTY);
                    } else {
                      return ListView.builder(
                          itemCount: listasRecorridos.length,
                          itemBuilder: (context, i) => ItemWidget(
                              itemHeight:
                                  StylesItemData.ITEM_HEIGHT_THREE_TITLE,
                              iconPrimary: IconsData.ICON_USER,
                              iconSend: IconsData.ICON_SEND_ARROW,
                              itemIndice: i,
                              methodAction: onPressRecorrido,
                              colorItem: i % 2 == 0
                                  ? StylesThemeData.ITEM_SHADED_COLOR
                                  : StylesThemeData.ITEM_UNSHADED_COLOR,
                              titulo: listasRecorridos[i].nombre,
                              subtitulo:
                                  "${listasRecorridos[i].horaInicio} - ${listasRecorridos[i].horaFin}",
                              subSecondtitulo: listasRecorridos[i].usuario,
                              styleTitulo: StylesTitleData.STYLE_TITLE,
                              styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
                              styleSubSecondtitulo:
                                  StylesTitleData.STYLE_SECOND_SUBTILE,
                              iconColor: StylesThemeData.ICON_COLOR));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados",
                        IconsData.ICON_ERROR_EMPTY);
                  }
                }
            }
          });
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Nueva entrega en sede"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    width: double.infinity,
                    child: InputWidget(
                        iconPrefix: Icons.search,
                        methodOnPressed: null,
                        methodOnChange: onChanged,
                        controller: _destinatarioController,
                        focusInput: f1Destinatario,
                        hinttext: 'Ingresar nombre'))),
                Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: _crearListadoporfiltro(textdestinatario)),
                )
              ],
            ),
            context));
  }
}
