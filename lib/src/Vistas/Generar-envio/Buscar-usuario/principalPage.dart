import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  PrincipalController principalcontroller = new PrincipalController();
  int cantidad = obtenerCantidadMinima();
  String textdestinatario = "";
  final _usuarioController = TextEditingController();
  FocusNode focusUsuario = FocusNode();
  List<UsuarioFrecuente> listusuarios;
  @override
  void initState() {
    super.initState();
  }

  void onPressedItemWidget(dynamic indiceUsuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EnvioPage(usuariopage: listusuarios[indiceUsuario]),
      ),
    );
  }

  void onchangeTextForm(dynamic valorTextForm) {
    setState(() {
      textdestinatario = valorTextForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _crearListadoporfiltro(String texto) {
      if (this.cantidad > texto.length && texto.length > 0) {
        return Container();
      } else {
        return FutureBuilder(
            future: principalcontroller.listarUsuariosporFiltro(texto),
            builder: (BuildContext context,
                AsyncSnapshot<List<UsuarioFrecuente>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                      child: new Text('No hay conexión con el servidor'));
                case ConnectionState.waiting:
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadingGet(),
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(child: new Text('Ha surgido un problema'));
                  } else {
                    if (snapshot.hasData) {
                      this.listusuarios = snapshot.data;
                      if (this.listusuarios.length == 0) {
                        return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                      } else {
                        return ListView.builder(
                            itemCount: this.listusuarios.length,
                            itemBuilder: (context, i) => ItemWidget(
                                iconPrimary: IconsData.ICON_USER,
                                iconSend: IconsData.ICON_ITEM_WIDGETRIGHT,
                                itemIndice: i,
                                methodAction: onPressedItemWidget,
                                colorItem: i % 2 == 0
                                    ? StylesThemeData.ITEM_SHADED_COLOR
                                    : StylesThemeData.ITEM_UNSHADED_COLOR,
                                titulo: this.listusuarios[i].nombre,
                                subtitulo:
                                    "${this.listusuarios[i].area} - ${this.listusuarios[i].sede}",
                                subSecondtitulo: null,
                                styleTitulo: TextStyle(fontSize: 15),
                                styleSubTitulo: TextStyle(fontSize: 12),
                                styleSubSecondtitulo: null,
                                iconColor: StylesThemeData.ICON_COLOR));
                      }
                    } else {
                      return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                    }
                  }
              }
            });
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        text: "Generar envío",
        leadingbool: boolIfPerfil() ? false : true,
      ),
      drawer: drawerIfPerfil(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          paddingWidget(Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: InputWidget(
                      controller: _usuarioController,
                      focusInput: focusUsuario,
                      hinttext: 'Ingrese destinatario',
                      methodOnChange: onchangeTextForm,
                      iconPrefix: Icons.search,
                    )), 
                Container(
                    child: textdestinatario != ""
                        ? Container()
                        : Text("Usuarios frecuentes",
                            style: TextStyle(
                                fontSize: 15,
                                color: StylesThemeData.LETTER_COLOR))),
              ])),
          Expanded(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: _crearListadoporfiltro(textdestinatario)),
          )
        ],
      ),
    );
  }
}
