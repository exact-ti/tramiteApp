import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'EntregaPersonalizadaController.dart';

class EntregapersonalizadoPageDNI extends StatefulWidget {
  @override
  _EntregapersonalizadoPageDNIState createState() =>
      new _EntregapersonalizadoPageDNIState();
}

class _EntregapersonalizadoPageDNIState
    extends State<EntregapersonalizadoPageDNI> {
  final _sobreController = TextEditingController();
  final _dniController = TextEditingController();
  EntregaPersonalizadaController personalizadacontroller =
      new EntregaPersonalizadaController();
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoDNI = "";
  String codigoSobre = "";
  String textdestinatario = "";
  bool inicio = true;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  var nuevo = 0;
  bool isSwitched = true;
  var validarSobre = false;
  var validarBandeja = false;
  bool confirmaciondeenvio = false;
  int indice = 0;
  int indicebandeja = 0;
  List<String> listacodigos = new List();
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  @override
  void initState() {
    valuess = "";
    listacodigos = [];
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _dniController.clear();
    });
  }

  void notifierAccion(String mensaje, String color) {
    final snack = new SnackBar(
      content: new Text("Se registró el envío"),
      backgroundColor: primaryColor,
    );
    scaffoldkey.currentState.showSnackBar(snack);
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {

    void _validarSobreText(String value) async {
      if (value != "") {
        if (!listacodigos.contains(value)) {
          bool respuesta = await personalizadacontroller.guardarEntrega(
              context, _dniController.text, value);
          if (respuesta) {
            desenfocarInputfx(context);
            listacodigos.add(value);
            setState(() {
              _sobreController.text = "";
              codigoSobre = "";
              listacodigos = listacodigos;
            });
            notifierAccion("El envío $value fue entregado correctamente", "38CE00");
          } else {
            popuptoinput(
                context, f2, "error", "EXACT", "El código no existe, por favor intente nuevamente");
          }
        } else {
          popuptoinput(
              context, f2, "error", "EXACT", "Código ya se encuentra validado");
        }
      } else {
        popuptoinput(
            context, f2, "error", "EXACT", "El código de sobre es obligatorio");
      }
    }

    void _validarDNIText(String value) {
      if (value != "") {
        setState(() {
          codigoDNI = value;
          _dniController.text = value;
        });
      }
    }

    final textDNI = Container(
      child: Text("Código"),
    );

    final textSobre = Container(
      child: Text("Código de sobre"),
    );

    Future _traerdatosescanerSobre() async {
      qrbarra = await getDataFromCamera();
      if (_dniController.text == "") {
        _sobreController.text = "";
        notificacion(context, "error", "EXACT", "Primero debe ingresar el DNI");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerDNI() async {
      qrbarra = await getDataFromCamera();
      _validarDNIText(qrbarra);
    }

    var campoDNI = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f1,
      controller: _dniController,
      onFieldSubmitted: (value) {
        if (value.length == 0) {
          popuptoinput(context, f1, "error", "EXACT", "El DNI es obligatorio");
        } else {
          enfocarInputfx(context, f2);
        }
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
      ),
    );

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f2,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (_dniController.text == "") {
          popuptoinput(context, f1, "error", "EXACT",
              "Ingrese primero el DNI para asociar a la entrega personalizada");
        } else {
          _validarSobreText(value);
        }
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        filled: true,
        fillColor: Color(0xFFEAEFF2),
        errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xFFEAEFF2),
            width: 0.0,
          ),
        ),
      ),
    );

    final campodetextoandIconoDNI = Row(children: <Widget>[
      Expanded(
        child: campoDNI,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerDNI),
        ),
      ),
    ]);

    final campodetextoandIconoSobre = Row(children: <Widget>[
      Expanded(
        child: sobre,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerSobre),
        ),
      ),
    ]);

    Widget crearItem(String codigopaquete) {
      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            title: Text("$codigopaquete"),
            leading: FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
            trailing: Icon(
              Icons.check,
              color: Color(0xffC7C7C7),
            ),
          ));
    }

    Widget _crearListadoinMemoria(List<String> validados) {
      return ListView.builder(
          itemCount: validados.length,
          itemBuilder: (context, i) => crearItem(validados[i]));
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        key: scaffoldkey,
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 30),
                          width: double.infinity,
                          child: textDNI,
                          margin: const EdgeInsets.only(top: 50),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoDNI),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            child: textSobre),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 12),
                          width: double.infinity,
                          child: campodetextoandIconoSobre,
                          margin: const EdgeInsets.only(bottom: 40),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: _crearListadoinMemoria(listacodigos)),
                      ),
                    ],
                  ),
                ))));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
}
