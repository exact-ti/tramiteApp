import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/shared/modals/tracking.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';
import 'RecepcionController.dart';

class RecepcionEnvioPage extends StatefulWidget {
  @override
  _RecepcionEnvioPageState createState() => new _RecepcionEnvioPageState();
}

class _RecepcionEnvioPageState extends State<RecepcionEnvioPage> {
  final _bandejaController = TextEditingController();
  List<String> listaEnvios = new List();
  List<EnvioModel> listaEnviosModel = new List();
  RecepcionController principalcontroller = new RecepcionController();
  Map<String, dynamic> validados = new HashMap();
  bool respuestaBack = false;
  final NavigationService _navigationService = locator<NavigationService>();
  FocusNode f1 = FocusNode();
  @override
  void initState() {
    inicializarEnviosRecepcion();
    super.initState();
  }

  inicializarEnviosRecepcion() async {
    listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
    listaEnviosModel.forEach((element) {
      String cod = element.codigoPaquete;
      validados["$cod"] = false;
    });
    setState(() {
      respuestaBack = true;
      listaEnviosModel = listaEnviosModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(EnvioModel entrega) {
      String codigopaquete = entrega.codigoPaquete;
      return GestureDetector(
          onLongPress: () {
            setState(() {
              validados["$codigopaquete"] = true;
            });
          },
          onTap: () {
            bool contienevalidados = validados.containsValue(true);
            if (contienevalidados && validados["$codigopaquete"] == false) {
              setState(() {
                validados["$codigopaquete"] = true;
              });
            } else {
              setState(() {
                validados["$codigopaquete"] = false;
              });
            }
          },
          child: Container(
              height: 70,
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              decoration: myBoxDecorationselect(validados["$codigopaquete"]),
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 35,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'De ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                          TextSpan(
                              text: entrega.usuario == null
                                  ? 'Envío importado'
                                  : '${entrega.usuario}',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          child: Row(
                    children: <Widget>[
                      validados["$codigopaquete"] == null ||
                              validados["$codigopaquete"] == false
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: Text("$codigopaquete",
                                    style: TextStyle(color: Colors.blue)),
                                onTap: () {
                                  if (!validados.containsValue(true)) {
                                    trackingPopUp(context, entrega.id);
                                  }
                                },
                              ))
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: Text("$codigopaquete",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("${entrega.observacion}")))
                    ],
                  )))
                ],
              )));
    }

    void validarEnvio(List<String> listid, int cantidad) async {
      bool respuestaLista =
          await principalcontroller.guardarLista(context, listid);
      if (respuestaLista) {
        notificacion(
            context,
            "success",
            "EXACT",
            cantidad == 1
                ? "Se recepcionó el envío"
                : "Se recepcionó los envíos");
        _navigationService.showModal();
        listaEnviosModel = await principalcontroller.listarEnviosPrincipal();
        validados.clear();
        listaEnviosModel.forEach((element) {
          String cod = element.codigoPaquete;
          validados["$cod"] = false;
        });
        _navigationService.goBack();
        setState(() {
          validados = validados;
          _bandejaController.text = "";
          listaEnviosModel = listaEnviosModel;
        });
      } else {
        notificacion(
            context,
            "error",
            "EXACT",
            cantidad == 1
                ? "No es posible procesar el código"
                : "No es posible procesar los códigos");
        validados.clear();
        setState(() {
          _bandejaController.text = "";
        });
      }
    }

    void _validarBandejaText(dynamic valueBandejaController) {
      if (valueBandejaController != "") {
        List<String> lista = new List();
        lista.add(valueBandejaController);
        validarEnvio(lista, 1);
      }
    }

    Future _traerdatosescanerBandeja() async {
      if (!validados.containsValue(true)) {
        _bandejaController.text = await getDataFromCamera(context);
        setState(() {
          _bandejaController.text = _bandejaController.text;
        });
        _validarBandejaText(_bandejaController.text);
      }
    }

    void registrarLista() {
      List<String> listid = new List();
      validados
          .forEach((k, v) => v == true ? listid.add(k) : print("no pertenece"));
      validarEnvio(listid, 2);
    }

    Widget _crearListado(List<EnvioModel> listaEnv) {
      if (listaEnv.length == 0)
        return Container(
            child: Center(
                child: sinResultados("No hay envíos para recepcionar",
                    IconsData.ICON_ERROR_EMPTY)));
      return ListView.builder(
          itemCount: listaEnv.length,
          itemBuilder: (context, i) => crearItem(listaEnv[i]));
    }

    mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 30),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: InputCameraWidget(
                  inputParam: InputWidget(
                      controller: _bandejaController,
                      focusInput: f1,
                      methodOnPressed: _validarBandejaText,
                      hinttext: "Envío"),
                  onPressed: _traerdatosescanerBandeja,
                  iconData: Icons.camera_alt,
                )),
            !respuestaBack
                ? Expanded(
                    child: Container(
                        child: Center(
                            child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadingGet(),
                  ))))
                : Expanded(
                    child: Container(child: _crearListado(listaEnviosModel))),
            validados.containsValue(true)
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: ButtonWidget(
                        onPressed: registrarLista,
                        colorParam: StylesThemeData.PRIMARY_COLOR,
                        texto: "Recepcionar"))
                : Container()
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          text: "Confirmar envíos",
          leadingbool: boolIfPerfil() ? false : true,
        ),
        drawer: drawerIfPerfil(),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }

  BoxDecoration myBoxDecorationselect(bool seleccionado) {
    return BoxDecoration(
      border: Border.all(color: StylesThemeData.LETTER_COLOR),
      color: seleccionado == null || seleccionado == false
          ? Colors.white
          : StylesThemeData.SELECTION_COLOR,
    );
  }
}
