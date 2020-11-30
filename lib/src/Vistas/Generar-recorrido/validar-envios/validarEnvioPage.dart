import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ListItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';

class ValidacionEnvioPage extends StatefulWidget {
  final RecorridoModel recorridopage;
  const ValidacionEnvioPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _ValidacionEnvioPageState createState() =>
      _ValidacionEnvioPageState(recorridopage);
}

class _ValidacionEnvioPageState extends State<ValidacionEnvioPage> {
  RecorridoModel recorridoUsuario;
  _ValidacionEnvioPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  List<EnvioModel> listaEnvios;
  ValidacionController validacionController = new ValidacionController();
  FocusNode focusSobre = FocusNode();
  int recorridoId;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => listarEnviosToValidar());
    super.initState();
  }

  void listarEnviosToValidar() async {
    if (this.mounted) {
      Map recorrido = ModalRoute.of(context).settings.arguments;
      recorridoId = recorrido['recorridoId'];
      listaEnvios = await validacionController
          .validacionEnviosController(this.recorridoId);
      setState(() {
        recorridoId = recorridoId;
        listaEnvios = listaEnvios;
      });
    }
  }

  void _validarText(dynamic value) async {
    desenfocarInputfx(context);
    if (value != "") {
      bool perteneceLista = listaEnvios
          .where((envio) => envio.codigoPaquete == value)
          .toList()
          .isNotEmpty;
      if (perteneceLista) {
        setState(() {
          listaEnvios.forEach((envio) {
            if (envio.codigoPaquete == value) {
              envio.estado = true;
            }
          });
        });
        if (listaEnvios.where((envio) => !envio.estado).toList().isNotEmpty) {
          selectionText(_sobreController, focusSobre, context);
        }
      } else {
        EnvioModel envioModel = await validacionController.validarCodigo(
            value, this.recorridoId, context);
        if (envioModel != null) {
          envioModel.estado = true;
          setState(() {
            listaEnvios.add(envioModel);
          });
          bool respuesta = await notificacion(
              context, "success", "EXACT", "El envío $value fue agregado");
          if (respuesta) {
            if (listaEnvios
                .where((envio) => !envio.estado)
                .toList()
                .isNotEmpty) {
              selectionText(_sobreController, focusSobre, context);
            }
          }
        } else {
          popupToInputShade(context, _sobreController, focusSobre, "error",
              "EXACT", "El envío $value no pertenece al recorrido");
        }
      }
    } else {
      popuptoinput(context, focusSobre, "error", "EXACT",
          "Es necesario ingresar el código del documento");
    }
  }

  Future _traerdatosescanerbandeja() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text;
    });
    _validarText(_sobreController.text);
  }

  void onPressed() async {
    if (listaEnvios.where((envio) => !envio.estado).toList().isEmpty) {
      validacionController.confirmacionDocumentosValidados(
          listaEnvios, context, recorridoId);
    } else {
      bool respuestaarray = await confirmarArray(
          context,
          "success",
          "EXACT",
          "Te faltan asociar estos documentos",
          listaEnvios.where((envio) => !envio.estado).toList());
      if (respuestaarray) {
        validacionController.confirmacionDocumentosValidados(
            listaEnvios.where((envio) => envio.estado).toList(),
            context,
            recorridoId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget itemEnvios(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_ONE_TITLE,
          iconPrimary: FontAwesomeIcons.qrcode,
          iconSend: listaEnvios[indice].estado
              ? IconsData.ICON_ENVIO_CONFIRMADO
              : null,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listaEnvios[indice].codigoPaquete,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Validación de documentos"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 30, bottom: 20),
                      width: double.infinity,
                      child: InputWidget(
                        iconSufix: IconsData.ICON_CAMERA,
                        methodOnPressedSufix: _traerdatosescanerbandeja,
                        methodOnPressed: _validarText,
                        controller: _sobreController,
                        focusInput: focusSobre,
                        hinttext: "Ingrese código",
                        iconPrefix: IconsData.ICON_SOBRE,
                      )),
                ),
                ListItemWidget(
                  itemWidget: itemEnvios,
                  listItems: listaEnvios,
                  mostrarMensaje: true,
                ),
                listaEnvios != null
                    ? paddingWidget(Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 40),
                        child: ButtonWidget(
                            iconoButton: listaEnvios.length == 0
                                ? IconsData.ICON_RECOJO
                                : IconsData.ICON_NEW,
                            onPressed: onPressed,
                            colorParam: StylesThemeData.PRIMARY_COLOR,
                            texto: listaEnvios.length == 0
                                ? 'Crear solo recojo'
                                : 'Crear recorrido')))
                    : Container()
              ],
            ),
            context));
  }
}
