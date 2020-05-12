import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/EntregaPersonalizadaPage.dart';

import 'EntregaRegularController.dart';

class EntregaRegularPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const EntregaRegularPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _EntregaRegularPageState createState() =>
      new _EntregaRegularPageState(recorridopage);
}

class _EntregaRegularPageState extends State<EntregaRegularPage> {
  RecorridoModel recorridoUsuario;
  _EntregaRegularPageState(this.recorridoUsuario);
  EntregaregularController envioController = new EntregaregularController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  //final _sobreController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  EntregaregularController principalcontroller = new EntregaregularController();
  //EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, _label, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String mensaje = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  String textdestinatario = "";
  int numeroRecorrido;
  List<String> listaCodigosValidados = new List();
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
  String _name = '';
  int indice = 0;
  int indicebandeja = 0;
  @override
  void initState() {
    numeroRecorrido = recorridoUsuario.id;
    valuess = "";
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              /*
              indice = 1;
              indicebandeja = 1;

              if (_formKey.currentState.validate() && validarenvio()) {
                setState(() {
                    confirmaciondeenvio=true;
                });
                print("SI puede enviar");
                envioController.crearEnvio(context,1, recordObject.id,_sobreController.text,_bandejaController.text,_observacionController.text);
                setState(() {
                  _sobreController.text="";
                  _bandejaController.text="";
                  _observacionController.text="";
                });
              } else {
                print("No se puede enviar");
              }*/
              //performLogin(context);
              //Navigator.of(context).pushNamed("principal");
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ));

    void registrarDocumento(String documento) async {
      bool pertenecia = false;
      for (EnvioModel envio in listaEnvios) {
        if (envio.codigoPaquete == documento) {
          pertenecia = true;
        }
      }
      if (pertenecia == true) {
        if (isSwitched) {
          dynamic respuestaMap =
              await envioController.recogerdocumentoRecojo(context,
                  recorridoUsuario.id, codigoBandeja, documento, isSwitched);

          if (respuestaMap.containsValue("success")) {
            dynamic respuestaMap2  =respuestaMap["data"];
            mensaje = respuestaMap2["destino"];
            listaEnvios
                .removeWhere((value) => value.codigoPaquete == documento);
          } else {
            mensaje = respuestaMap["message"];
          }
        } else {
          bool respuestaMap = await envioController.recogerdocumentoEntrega(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (respuestaMap) {
            listaEnvios
                .removeWhere((value) => value.codigoPaquete == documento);
          } else {
            mostrarAlerta(
                context, "no se pudo completar la operación", "mensaje");
          }
        }
        setState(() {
          mensaje = mensaje;
          listaEnvios = listaEnvios;
        });
      } else {
        if (isSwitched) {
          HashMap<String, dynamic> respuestaMap =
              await envioController.recogerdocumentoRecojo(context,
                  recorridoUsuario.id, codigoBandeja, documento, isSwitched);
          if (respuestaMap.containsValue("success")) {
            dynamic respuestaMap2  =respuestaMap["data"];
            mensaje = respuestaMap2["data"];
                      } else {
            mensaje = respuestaMap["message"];
          }
        } else {
          bool respuestaMap = await envioController.recogerdocumentoEntrega(
              context,
              recorridoUsuario.id,
              codigoBandeja,
              documento,
              isSwitched);
          if (!respuestaMap) {
            mostrarAlerta(
                context, "no se pudo completar la operación", "mensaje");
          }else{
            mostrarAlerta(
                context, "Se registro la entrega", "mensaje");            
          } 
        }
      }
    }

    void _validarSobreText(String value) {
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
            //listaCodigosValidados.add(value);
          });
        } else {
          setState(() {
            _sobreController.text = "";
            //codigoSobre = value;
          });
        }
         registrarDocumento(value);

      }
    }

    void _validarBandejaText(String value) {
      if (value != "") {
        setState(() {
          codigoBandeja = value;
          _bandejaController.text = value;
        });
      }
    }

    final botonesinferiores = Row(children: [
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EntregapersonalizadoPage(recorridopage: recorridoUsuario),
              ),
            );
          },
          child: Text(
            'Entrega Personalizada',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        flex: 5,
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            envioController.redirectMiRuta(recorridoUsuario, context);
          },
          child: Text(
            'Mi ruta',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    ]);

    final valorswitch = Center(
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            _sobreController.text = "";
            _bandejaController.text = "";
            listaEnvios.clear();
            listaEnviosValidados.clear();
            listaEnviosNoValidados.clear();
            codigoValidar = "";
            codigoBandeja = "";
            codigoSobre = "";
            textdestinatario = "";
            listaCodigosValidados.clear();
            isSwitched = value;
            mensaje="";
          });
        },
        activeTrackColor: SecondColor,
        activeColor: PrimaryColor,
      ),
    );

    final textBandeja = Container(
      child: Text("Código de bandeja"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código de sobre"),
      margin: const EdgeInsets.only(left: 15),
    );

    void agregaralista(EnvioModel envio) {
      bool pertenece = false;
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {
        for (EnvioModel envioModel in listaEnvios) {
          if (envioModel.id == envio.id) {
            pertenece = true;
          }
        }
        if (!pertenece) {
          //setState(() {
          listaEnvios.add(envio);
          //});
        }
      }
    }

    Widget crearItem(EnvioModel envio) {
      String codigopaquete = envio.codigoPaquete;
      agregaralista(envio);

      return Container(
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            title: Text("$codigopaquete"),
            leading: FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
            trailing: Text(""),
          ));
    }

    Future _traerdatosescanerSobre() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (codigoBandeja == "") {
        _sobreController.text = "";
        mostrarAlerta(context, "Primero debe ingresar el codigo de la bandeja",
            "Ingreso incorrecto");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarBandejaText(qrbarra);
    }

    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarEnvios(
              context, recorridoUsuario.id, codigoBandeja, isSwitched),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            if (snapshot.hasData) {
              final envios = snapshot.data;
              return ListView.builder(
                  itemCount: envios.length,
                  itemBuilder: (context, i) => crearItem(envios[i]));
            } else {
              return Container();
            }
          });
    }

    Widget _crearListadoinMemoria(List<EnvioModel> lista) {
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i]));
    }

/*
        Widget _crearListadoAgregar(
        List<String> validados, String codigoporValidar) {
      return FutureBuilder(
          future: principalcontroller.validarCodigo(
              codigoporValidar, recorridoUsuario.id, context),
          builder: (BuildContext context, AsyncSnapshot<EnvioModel> snapshot) {
            codigoValidar = "";
            if (snapshot.hasData) {
              final envio = snapshot.data;
              listaEnvios.add(envio);
              validados.add(envio.codigoPaquete);
              return ListView.builder(
                  itemCount: listaEnvios.length,
                  itemBuilder: (context, i) =>
                      crearItem(listaEnvios[i], validados));
            } else {
              if (listaEnvios.length != 0) {
                return ListView.builder(
                    itemCount: listaEnvios.length,
                    itemBuilder: (context, i) =>
                        crearItem(listaEnvios[i], validados));
              } else {
                return Container();
              }
            }
          });
    }
*/
    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _validarBandejaText(value);
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
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoBandeja == "") {
          _sobreController.text = "";
          mostrarAlerta(
              context,
              "Primero debe ingresar el codigo de la bandeja",
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

    Widget _validarListado(String codigo, List<EnvioModel> lista) {
      if (codigo == "") {
        return _crearListado();
      } else {
        return _crearListadoinMemoria(lista);
      }
    }

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: bandeja,
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerBandeja),
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

    final contenerSwitch2 = Container(
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        valorswitch,
        Expanded(
          child: Container(
            child: isSwitched != true ? Text("En entrega") : Text("En recojo"),
          ),
          flex: 3,
        )
      ]),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Entrega $numeroRecorrido en sede',
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
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: contenerSwitch2,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    //width: double.infinity,
                    child: textSobre),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoSobre,
                  margin: const EdgeInsets.only(bottom: 40),
                ),
              ),
              mensaje.length==0 ? Container():Text("$mensaje"), 
              Expanded(
                  child: codigoBandeja == ""
                      ? Container()
                      : Container(child: _validarListado(codigoSobre,listaEnvios))),
              /*Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 8),
                    width: double.infinity,
                    child: sendButton),
              ),*/
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
//                  Navigator.of(context).pushNamed(men.link);
