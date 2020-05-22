import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';

import 'RecepcionController.dart';

class RecepcionEnvioPage extends StatefulWidget {
  @override
  _RecepcionEnvioPageState createState() => new _RecepcionEnvioPageState();
}

class _RecepcionEnvioPageState extends State<RecepcionEnvioPage> {
  final _bandejaController = TextEditingController();
  List<String> listaEnvios = new List();
  RecepcionController principalcontroller = new RecepcionController();
  Map<String, dynamic> validados = new HashMap();
  String qrsobre, qrbarra = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  var listadetinatario;
  var colorletra = const Color(0xFFACADAD);
  bool isSwitched = false;
  var colorseleccion = const Color(0xFFB7DCEE);

  @override
  void initState() {
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);

    void _validarBandejaText(String value) {
      if (value != "") {
        setState(() {
          codigoBandeja = value;
          _bandejaController.text = "";
        });
      }
    }

    void agregaralista(EnvioModel envioModel){
        listaEnvios.add(envioModel.codigoPaquete);
    }


    Widget crearItem(EnvioModel entrega) {
      String codigopaquete = entrega.codigoPaquete;
      String destinatario = entrega.usuario;
      String observacion = entrega.observacion;
      int id  = entrega.id;
      agregaralista(entrega);
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
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                      text: 'De',
                      style: TextStyle(color: Colors.black,fontSize: 17)),
                  TextSpan(
                      text: ' $destinatario',
                      style: TextStyle(color: Colors.blueGrey,fontSize: 17)),
                ],
              ),
            ),),
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
                                    trackingPopUp(context, id);
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
                              child: Text("$observacion")))
                    ],
                  )))
                ],
              )));
    }
/*
    Widget crearItem(EnvioModel envio) {
      String destinatario = envio.usuario;
      String codigo = envio.codigoPaquete;
      String observacion = envio.observacion;
      agregaralista(envio);
      return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: myBoxDecoration(),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  height: 35,
                  child: Text("Para $destinatario")),
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Text("$codigo",
                            style: TextStyle(color: Colors.blue)),
                        onTap: () {
                        trackingPopUp(context, codigo);
                        },
                      )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("En custodia en UTD $observacion")))
                ],
              )))
            ],
          ));
    }*/

    Future _traerdatosescanerBandeja() async {
      if (!validados.containsValue(true)) {
        qrbarra =
            await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
        _validarBandejaText(qrbarra);
      }
    }

    void validarEnvio(List<String> listid) async {
      bool respuestaLista =
          await principalcontroller.guardarLista(context, listid);
      if (respuestaLista) {
        mostrarAlerta(context, "Se recepcionó los envíos",
            "Recepcion correcta");
        setState(() {
          validados.clear();
          codigoBandeja = codigoBandeja;
        });
      } else {
        mostrarAlerta(context, "No es posible procesar el código",
            "Recepcion incorrecta");
        validados.clear();
        setState(() {
          codigoBandeja = codigoBandeja;
        });
      }
    }

    final sendButton2 = Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          List<String> listid = new List();
          validados.forEach(
              (k, v) => v == true ? listid.add(k) : print("no pertenece"));
          validarEnvio(listid);
        },
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        color: Color(0xFF2C6983),
        child: Text('Recepcionar', style: TextStyle(color: Colors.white)),
      ),
    );

    Widget _crearListado(String codigo) {
      return FutureBuilder(
          future: principalcontroller.listarEnviosPrincipal(
              context, listaEnvios, codigo),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            if (snapshot.hasData) {
              final envios = snapshot.data;
              codigoBandeja ="";
              listaEnvios.clear();
              return ListView.builder(
                  itemCount: envios.length,
                  itemBuilder: (context, i) => crearItem(envios[i]));
            } else {
              return Container();
            }
          });
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
      if (!validados.containsValue(true)) {
       _validarBandejaText(value);
      }else{
        _bandejaController.text="";
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Recepción de envíos',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child:Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: principalcontroller.labeltext("Envío")),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoBandeja),
              ),
              Expanded(child: Container(child: _crearListado(codigoBandeja))),
              validados.containsValue(true)
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.center,
                          height: screenHeightExcludingToolbar(context,
                              dividedBy: 8),
                          width: double.infinity,
                          child: sendButton2),
                    )
                  : Container()
            ],
          ),
        ))));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  BoxDecoration myBoxDecorationselect(bool seleccionado) {
    return BoxDecoration(
      border: Border.all(color: colorletra),
      color: seleccionado == null || seleccionado == false
          ? Colors.white
          : colorseleccion,
    );
  }
}
