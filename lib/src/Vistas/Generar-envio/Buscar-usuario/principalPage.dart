import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

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
    Navigator.of(context).pushNamed(
      '/crear-envio',
      arguments: {
        'id': listusuarios[indiceUsuario].id,
        'area': listusuarios[indiceUsuario].area,
        'nombre': listusuarios[indiceUsuario].nombre,
        'sede': listusuarios[indiceUsuario].sede,
      },
    );
  }

  void onchangeTextForm(dynamic valorTextForm) {
    setState(() {
      textdestinatario = valorTextForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget itemWidget(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_TWO_TITLE,
          iconPrimary: IconsData.ICON_USER,
          iconSend: IconsData.ICON_SEND_ARROW,
          itemIndice: indice,
          methodAction: onPressedItemWidget,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: this.listusuarios[indice].nombre,
          subtitulo:
              "${this.listusuarios[indice].area} - ${this.listusuarios[indice].sede}",
          subSecondtitulo: null,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SECOND_SUBTILE,
          styleSubSecondtitulo: null,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    setList(List<dynamic> listUsuarios) {
      this.listusuarios = listUsuarios;
    }

    Widget listUsuariosByNombre(String texto) {
      if (this.cantidad > texto.length && texto.length > 0) {
        return Container();
      } else {
        return FutureItemWidget(
            itemWidget: itemWidget,
            setList: setList,
            futureList: principalcontroller.listarUsuariosporFiltro(texto));
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
          paddingWidget(
            Column(
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
                        modoLabel: false,
                      )),
                   Container(
                      child: textdestinatario != ""
                          ? Container()
                          : Text("Usuarios frecuentes",
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      StylesThemeData.LETTER_SECUNDARY_COLOR)))
                ]),
          ),
         /*  Container(
              child: textdestinatario != ""
                  ? Container()
                  : Card(
                      color: StylesThemeData.CARD_COLOR2,
                      margin: EdgeInsets.all(0),
                      child: Container(
                          height: 30,
                          child: Center(
                            child: Text("Usuarios frecuentes",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          )))), */
          listUsuariosByNombre(textdestinatario)
        ],
      ),
    );
  }
}
