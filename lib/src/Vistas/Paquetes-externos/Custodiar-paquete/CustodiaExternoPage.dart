import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoController.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCameraWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class CustodiaExternoPage extends StatefulWidget {
  @override
  _CustodiaExternoPageState createState() => new _CustodiaExternoPageState();
}

class _CustodiaExternoPageState extends State<CustodiaExternoPage> {
  
  CustodiaController custodiaController = new CustodiaController();

  var txtCodigoPaquete;

  var codigoPaqueteCamara = "";

  var codigoPaquete = "";

  List<PaqueteExterno> creados = new List<PaqueteExterno>();

  final _codigoController = TextEditingController();

  FocusNode f1 = FocusNode();

  Widget _crearListado() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
            future: _listarCreados(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PaqueteExterno>> snapshot) {
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
                      this.creados = snapshot.data;
                      if (this.creados.length == 0) {
                        return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                      } else {
                        return ListView.builder(
                            itemCount: this.creados.length,
                            itemBuilder: (context, i) =>
                                _crearItem(this.creados[i]));
                      }
                    } else {
                      return sinResultados("No se han encontrado resultados",IconsData.ICON_ERROR_EMPTY);
                    }
                  }
              }
            }),
      ),
    );
  }

  Widget _crearItem(PaqueteExterno paquete) {
    return Container(
      decoration: myBoxDecoration(StylesThemeData.LETTER_COLOR),
      margin: EdgeInsets.only(bottom: 5),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            child: new IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: Colors.grey,
                ),
                onPressed: () {
                  getDataFromCamera(context);
                }),
          ),
        ),
        Expanded(
          child: informacionPaquete(paquete),
          flex: 5,
        ),
      ]),
    );
  }

  Widget informacionPaquete(PaqueteExterno p) {
    return Container(
      height: 50,
      child: Container(
        height: 20,
        child: ListTile(title: Text(p.paqueteId)),
      ),
    );
  }

  Future<List<PaqueteExterno>> _listarCreados() async {
    List<PaqueteExterno> paqueteList =
        await custodiaController.listarPaquetesExternosCreados();
    return paqueteList;
  }

  void _custodiarPaquete(dynamic valueCodigoController) async {
    var codigo =valueCodigoController;

    if (codigo == "") {
      notificacion(context, "error", "EXACT",
          'Ingrese el código de paquete para custodiar el envío');
      return;
    }

    if (this.creados.length == 0) {
      notificacion(
          context, "error", "EXACT", 'No existen envíos para custodiar');
      return;
    }
    bool existeEnvio = _validarCodigo(codigo);

    if (existeEnvio == false) {
      popuptoinput(context, f1, "error", "EXACT",
          "El código ingresado no se encuentra en la lista de envíos por custodiar");
      return;
    }
    PaqueteExterno paq = new PaqueteExterno();
    paq.paqueteId = codigo;
    bool resp = await custodiaController.custodiarPaquete(paq);

    if (resp) {
      setState(() {
        this.codigoPaquete = "";
        _codigoController.text = "";
      });
      enfocarInputfx(context, f1);
      _crearListado();
    } else {
      popuptoinput(context, f1, "error", "EXACT",
          "No se pudo custodiar el paquete con código $codigo");
    }

    this.codigoPaquete = "";
  }

  bool _validarCodigo(String codigo) {
    bool existeEnvio = false;
    for (var item in this.creados) {
      if (item.paqueteId == codigo) {
        existeEnvio = true;
        break;
      }
    }
    return existeEnvio;
  }

  void _custodiarConCamara() async {
    _codigoController.text = await sd.getDataFromCamera(context);
    setState(() {
      _codigoController.text = _codigoController.text;
    });
    _custodiarPaquete(_codigoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Custodiar envíos"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: InputCameraWidget(
                            iconData: Icons.camera_alt,
                            onPressed: _custodiarConCamara,
                            inputParam: InputWidget(
                              controller: _codigoController,
                              focusInput: f1,
                              hinttext: "Ingresar código",
                              methodOnPressed: _custodiarPaquete,
                            )),
                      ),
                      _crearListado()
                    ],
                  ),
                )),
            context));
  }
}
