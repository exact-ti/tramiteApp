import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'RegistrarEntregaPersonalizadaController.dart';
class RegistrarEntregapersonalizadoPage extends StatefulWidget {
  final dynamic firma;

  const RegistrarEntregapersonalizadoPage({Key key, this.firma})
      : super(key: key);

  @override
  _RegistrarEntregapersonalizadoPageState createState() =>
      new _RegistrarEntregapersonalizadoPageState(firma);
}

class _RegistrarEntregapersonalizadoPageState
    extends State<RegistrarEntregapersonalizadoPage> {
  dynamic imagenFirma;
  _RegistrarEntregapersonalizadoPageState(this.imagenFirma);
  final _sobreController = TextEditingController();
  final _firmaController = TextEditingController();
  RegistrarEntregaPersonalizadaController personalizadacontroller =
      new RegistrarEntregaPersonalizadaController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoFIRMA = "";
  String codigoSobre = "";
  String textdestinatario = "";
  bool inicio = true;
  String respuestaBack = "";
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
  bool colorRespuesta = true;
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
      if (_focusNode.hasFocus) _firmaController.clear();
    });
  }

  var colorplomos = const Color(0xFFEAEFF2);

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF4D828D);

    void _validarSobreText(String value) async {
      if (value != "") {
/*         if (!listacodigos.contains(value)) {
 */
        dynamic respuesta = await personalizadacontroller.guardarEntrega(
            context, imagenFirma, value);
        if (respuesta.containsValue("success")) {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
          listacodigos.add(value);
          setState(() {
            respuestaBack = "El envío $value fue entregado correctamente";
            _sobreController.text = "";
            codigoSobre = "";
            listacodigos = listacodigos;
            colorRespuesta = true;
          });
        } else {
          setState(() {
            respuestaBack = respuesta["message"];
            _sobreController.text = "";
            colorRespuesta = false;
            codigoSobre = "";
            listacodigos = listacodigos;
          });
          f1.unfocus();
          FocusScope.of(context).requestFocus(f2);
        }
/*         } else {
          mostrarAlerta(context, "Codigo ya se encuentra validado", "Mensaje");
        } */
      }
    }

    void _validarFIRMAText(String value) {
      if (value != "") {
        setState(() {
          codigoFIRMA = value;
          _firmaController.text = value;
        });
      }
    }

    final textFIRMA = Container(
      child: Text("Firma"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código de sobre"),
      margin: const EdgeInsets.only(left: 15),
    );

    Future _traerdatosescanerSobre() async {
      qrbarra  = await getDataFromCamera();
      _validarSobreText(qrbarra);
    }

    Future _traerdatosescanerFIRMA() async {
      qrbarra  = await getDataFromCamera();
      _validarFIRMAText(qrbarra);
    }

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f2,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (value.length == 0) {
          notificacion(
              context, "error", "EXACT", "El codigo de sobre es obligatorio");
          f1.unfocus();
          FocusScope.of(context).requestFocus(f2);
        } else {
          if (_firmaController.text == "") {
            _sobreController.text = "";
            notificacion(context, "error", "EXACT",
                "La firma es necesario para la entrega");
          } else {
            _validarSobreText(value);
          }
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

    final campodetextoandIconoFIRMA = Container(
      child: imagenFirma.length == 0
          ? Container()
          : LimitedBox(
              maxHeight: screenHeightExcludingToolbar(context, dividedBy: 5),
              child: Container(
                  child: RotationTransition(
                      turns: new AlwaysStoppedAnimation(90 / 360),
                      child: Container(
                          child: Image.memory(
                              Base64Decoder().convert(imagenFirma)))))),
    );

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
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Entrega personalizada',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),/* 
        drawer: crearMenu(context), */
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
                          child: textFIRMA,
                          margin: const EdgeInsets.only(top: 50),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          child: campodetextoandIconoFIRMA,
                        ),
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
                      Align(
                        alignment: Alignment.center,
                        child: respuestaBack.length == 0
                            ? Container()
                            : Container(
                                alignment: Alignment.center,
                                color:
                                    colorRespuesta ? SecondColor : Colors.grey,
                                child: Center(
                                    child: Text("$respuestaBack",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20)))),
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
