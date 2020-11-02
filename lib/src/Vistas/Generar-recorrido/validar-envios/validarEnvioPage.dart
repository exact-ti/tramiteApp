import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/CustomButton.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/shared/Widgets/ListCod.dart';
import 'package:tramiteapp/src/shared/modals/confirmationArray.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

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
  FocusNode f1 = FocusNode();

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

  void _validarText() async {
    String value = _sobreController.text;
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
        enfocarInputfx(context, f1);
      }
    } else {
      popuptoinput(context, f1, "error", "EXACT",
          "Es necesario ingresar el código del documento");
    }
  }

  Future _traerdatosescanerbandeja() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text;
    });
    _validarText();
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
    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                child: InputCamera(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerbandeja,
                    inputParam: InputForm(
                      onPressed: _validarText,
                      controller: _sobreController,
                      fx: f1,
                      hinttext: "",
                    ))),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: ListCod(enviosModel: listaEnvios,mensaje: "No se han encontrado resultados",)),
            ),
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 40),
                child: CustomButton(
                    onPressed: onPressed,
                    colorParam: StylesThemeData.PRIMARYCOLOR,
                    texto: listaEnvios.length == 0
                        ? 'Crear solo recojo'
                        : 'Crear recorrido'))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Validación de documentos"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
