import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';

import 'EntregaPersonalizadaController.dart';


class EntregapersonalizadoPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const EntregapersonalizadoPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _EntregaPersonalizadaPageState createState() =>
      new _EntregaPersonalizadaPageState(recorridopage);
}

class _EntregaPersonalizadaPageState extends State<EntregapersonalizadoPage> {
  RecorridoModel recorridoUsuario;
  _EntregaPersonalizadaPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  final _dniController = TextEditingController();
  //final _sobreController = TextEditingController();
  EntregaPersonalizadaController personalizadacontroller = new EntregaPersonalizadaController();
  //EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, _label, valuess = "";
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
  @override
  void initState() {
    valuess = "";
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);


    void _validarSobreText(String value) {
      if (value != "") {
        personalizadacontroller.guardarEntrega(context, recorridoUsuario.id,codigoDNI,value);
          setState(() {
            _sobreController.text = "";
            _dniController.text="";
            codigoSobre = "";
            codigoDNI="";
          });
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

    final botonesinferiores = Row(children: [
      Expanded(
        child: Container(),
        flex: 5,
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            personalizadacontroller.redirectMiRuta(recorridoUsuario,context);
          },
          child: Text(
            'volver',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    ]);

    final textDNI = Container(
      child: Text("DNI"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código de sobre"),
      margin: const EdgeInsets.only(left: 15),
    );



    Future _traerdatosescanerSobre() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (codigoDNI == "") {
        _sobreController.text = "";
        mostrarAlerta(context, "Primero debe ingresar el codigo de la bandeja",
            "Ingreso incorrecto");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerDNI() async {
      qrbarra =await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarDNIText(qrbarra);
    }

    var campoDNI = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _dniController,
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
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoDNI == "") {
          _sobreController.text = "";
          mostrarAlerta(
              context,
              "El DNI es necesario para la entrega",
              "Ingreso incorrecto");
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


    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Entrega 1025 en sede',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textDNI,
                    margin: const EdgeInsets.only(top: 50),
                    ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoDNI),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:screenHeightExcludingToolbar(context, dividedBy: 30),
                    child: textSobre),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoSobre,
                    margin: const EdgeInsets.only(bottom: 40),),
              ),
              Expanded(
                  child: Container()
                  ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: botonesinferiores),
              ),
            ],
          ),
        ));
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
