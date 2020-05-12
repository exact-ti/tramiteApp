import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/ModelDto/TurnoModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'ConsultaEnvioController.dart';

class ConsultaEnvioPage extends StatefulWidget {
  @override
  _ConsultaEnvioPageState createState() => new _ConsultaEnvioPageState();
}

class _ConsultaEnvioPageState extends State<ConsultaEnvioPage> {
  final _destinatarioController = TextEditingController();
  final _paqueteController = TextEditingController();
  final _remitenteController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<TurnoModel> listaTurnos = new List();
  List<EnvioModel> listaEnviosVacios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  ConsultaEnvioController principalcontroller = new ConsultaEnvioController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoPaquete = "";
  String codigoDestinatario = "";
  String codigoremitente = "";
  int cantidadPendientes = 0;
  int cantidadInicial = 0;
  String selectedFc;
  List<String> listaCodigosValidados = new List();
  bool inicio = true;
  var colorletra = const Color(0xFFACADAD);
  void initState() {
    super.initState();
    listaEnviosVacios = [];
    listaTurnos = [];
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    listarNovalidados() {
      bool esvalidado = false;
      List<dynamic> as = listaEnvios;
      List<dynamic> ads = listaCodigosValidados;
      for (EnvioModel envio in listaEnvios) {
        if (listaCodigosValidados.contains(envio.codigoPaquete)) {
          listaEnviosValidados.add(envio);
        } else {
          listaEnviosNoValidados.add(envio);
        }
      }
    }


    final sendButton = Container(
        margin: const EdgeInsets.only(top: 10),
        child:SizedBox(
            width: double.infinity,
            height: 60,
            child:RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
                    /*principalcontroller.confirmacionDocumentosValidados(
                        listaEnviosVacios,
                        context,
                        int.parse(selectedFc),
                        codigoPaquete);*/
            },
            color: Color(0xFF2C6983),
            child:
            Text('Buscar', style: TextStyle(color: Colors.white)),
          ),
          )
        );

    /*void _validarSobreText(String value) {
      if (value != "") {
        bool perteneceLista = false;
        for (EnvioModel envio in listaEnvios) {
          if (envio.codigoPaquete == value) {
            perteneceLista = true;
          }
        }
        if (perteneceLista) {
          setState(() {
            _sobreController.text = "";
            codigoSobre = value;
            listaCodigosValidados.add(value);
            codigoBandeja = _bandejaController.text;
          });
        } else {
          setState(() {
            _sobreController.text = "";
            codigoSobre = value;
            codigoBandeja = _bandejaController.text;
          });
        }
      }
    }*/

    void _validarPaqueteText(String value) async {
      codigoPaquete = value;
      _paqueteController.text = value;
    }

    void _validarRemitenteText(String value) async {
      codigoremitente = value;
      _remitenteController.text = value;
    }

    bool validarContiene(List<EnvioModel> lista, EnvioModel envio) {
      bool boleano = false;
      for (EnvioModel en in lista) {
        if (en.id == envio.id) {
          boleano = true;
        }
      }
      return boleano;
    }

    void _validarDestinatarioText(String value) async {
      codigoDestinatario = value;
      _destinatarioController.text = value;
    }

    final textPaquete = Container(
      child: Text("Paquete"),
    );

    final textRemitente = Container(
      child: Text("De"),
    );

    final textDestinatario = Container(
      child: Text("Para"),
    );

    void agregaralista(EnvioModel envio) {
      bool pertenece = false;
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {
        if (!listaEnvios.contains(envio)) {
          listaEnvios.add(envio);
        }
      }
    }

    Widget crearItem(EnvioModel envio, int i) {
      String codigopaquete = envio.codigoPaquete;
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
      /*else {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading:
                  FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
              trailing: Text(""),
            ));
      }*/
    }

    Future _traerdatosescanerDestinatario() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (_paqueteController.text == "") {
        _destinatarioController.text = "";
        mostrarAlerta(context, "Primero debe ingresar el codigo de la bandeja",
            "Ingreso incorrecto");
      } else {
        _validarDestinatarioText(qrbarra);
      }
    }

    Future _traerdatosescanerPaquete() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      _validarPaqueteText(qrbarra);
    }

    Future _traerdatosescanerRemitente() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      _validarRemitenteText(qrbarra);
    }

    /*Widget pendientes(int cantidad) {
      int cantidadp = listaEnvios.length - listaCodigosValidados.length;
      if(cantidadp==0){
          cantidadp=cantidad;
      }
      if (cantidadp == 1) {
        return Text("Queda $cantidadp documento pendiente");
      }
      return Text("Quedan $cantidad documentos pendientes");
    }*/
    var paquete = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _paqueteController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _validarPaqueteText(value);
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

    var remitente = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _paqueteController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _validarRemitenteText(value);
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

    var destinatario = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _destinatarioController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoPaquete == "") {
          _destinatarioController.text = "";
          mostrarAlerta(
              context,
              "Primero debe ingresar el codigo de la bandeja",
              "Ingreso incorrecto");
        } else {
          _validarDestinatarioText(value);
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

    Widget _crearListadoAgregar(List<EnvioModel> lista) {
      return Container();
      /*return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i], 1));*/
    }

    final campodetextoandIconoDestinatario = Row(children: <Widget>[
      Expanded(
        child: destinatario,
        flex: 5,
      ),
      Expanded(
        child:   Opacity(
              opacity: 0.0,
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                child: Icon(Icons.camera_alt),
              )),
      ),
    ]);

    final campodetextoandIconoPaquete = Row(children: <Widget>[
      Expanded(
        child: paquete,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerPaquete),
        ),
      ),
    ]);

    final campodetextoandIconoRemitente = Row(children: <Widget>[
      Expanded(
        child: remitente,
        flex: 5,
      ),
      Expanded(
        child: Opacity(
              opacity: 0.0,
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                child: Icon(Icons.camera_alt),
              )),
      ),
    ]);


    final campodetextoandIconoButton = Row(children: <Widget>[
      Expanded(
        child: sendButton,
        flex: 5,
      ),
      Expanded(
        child: Opacity(
              opacity: 0.0,
              child: Container(
                margin: const EdgeInsets.only(left: 15),
                child: Icon(Icons.camera_alt),
              )),
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
          title: Text('Consultas',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textPaquete),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoPaquete),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textRemitente),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoRemitente),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    //width: double.infinity,
                    child: textDestinatario),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoDestinatario,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoButton,
                ),
              ),
              Expanded(
                  child:Container(
                          child: _crearListadoAgregar(listaEnviosVacios))),
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

//                  Navigator.of(context).pushNamed(men.link);
