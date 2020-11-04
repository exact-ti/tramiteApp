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
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'package:tramiteapp/src/styles/title_style.dart';

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
  List<EnvioModel> listaEnvios = new List();
  ValidacionController validacionController = new ValidacionController();
  FocusNode focusSobre = FocusNode();

  @override
  void initState() {
    listarEnviosToValidar();
    super.initState();
  }

  void listarEnviosToValidar() async {
    listaEnvios = await validacionController
        .validacionEnviosController(this.recorridoUsuario.id);
    if (this.mounted) {
      setState(() {
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
      } else {
        EnvioModel envioModel = await validacionController.validarCodigo(
            value, recorridoUsuario.id, context);
        if (envioModel != null) {
          envioModel.estado = true;
          setState(() {
            listaEnvios.add(envioModel);
          });
          await notificacion(
              context, "success", "EXACT", "El envío $value fue agregado");
        } else {
          await notificacion(context, "error", "EXACT",
              "El envío $value no pertenece al recorrido");
        }
      }
      setState(() {
        _sobreController.text = "";
      });
      if (listaEnvios.where((envio) => !envio.estado).toList().isNotEmpty) {
        enfocarInputfx(context, focusSobre);
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
          listaEnvios, context, recorridoUsuario.id);
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
            recorridoUsuario.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: InputCameraWidget(
                          iconData: Icons.camera_alt,
                          onPressed: _traerdatosescanerbandeja,
                          inputParam: InputWidget(
                            methodOnPressed: _validarText,
                            controller: _sobreController,
                            focusInput: focusSobre,
                            hinttext: "",
                          ))),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.bottomCenter,
                  child: 
                  listaEnvios.isEmpty?sinResultados("No se han encontrado resultados", IconsData.ICON_ERROR_EMPTY) :ListView.builder(
                      itemCount: listaEnvios.length,
                      itemBuilder: (context, i) => ItemWidget(
                          iconPrimary: FontAwesomeIcons.qrcode,
                          iconSend: listaEnvios[i].estado
                              ? IconsData.ICON_ENVIO_CONFIRMADO
                              : null,
                          itemIndice: i,
                          methodAction: null,
                          colorItem: i % 2 == 0
                              ? StylesThemeData.ITEM_SHADED_COLOR
                              : StylesThemeData.ITEM_UNSHADED_COLOR,
                          titulo: listaEnvios[i].codigoPaquete,
                          subtitulo: null,
                          subSecondtitulo: null,
                          styleTitulo: StylesTitleData.STYLE_TITLE,
                          styleSubTitulo: null,
                          styleSubSecondtitulo: null,
                          iconColor: StylesThemeData.ICON_COLOR)),
                )),
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 40),
                    child: ButtonWidget(
                        onPressed: onPressed,
                        colorParam: StylesThemeData.PRIMARY_COLOR,
                        texto: listaEnvios.length == 0
                            ? 'Crear solo recojo'
                            : 'Crear recorrido'))
              ],
            ),
            context));
  }
}
