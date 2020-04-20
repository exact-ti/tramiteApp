import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'RecepcionController.dart';

class RecepcionValijaPage extends StatefulWidget {
  @override
  _RecepcionValijaPageState createState() => new _RecepcionValijaPageState();
}

class _RecepcionValijaPageState extends State<RecepcionValijaPage> {
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  RecepcionController principalcontroller = new RecepcionController();
  String qrsobre, qrbarra = "";
  String codigoSobre = "";
  var listadetinatario;
  var colorletra = const Color(0xFFACADAD);
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);

    void _validarSobreText(String value) {
      if (value != "") {
        setState(() {
          _sobreController.text = "";
          codigoSobre = value;
        });
      }
    }


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
        _validarSobreText(qrbarra);
    }


    Widget _crearListado() {
      return FutureBuilder(
          future: principalcontroller.listarEnvios(
              context),
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

    Widget sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              if (listaEnvios.length == 0) {
                listaEnvios.clear();
                _bandejaController.text = "";
                _sobreController.text = "";
                codigoSobre = "";
              } else {
                confirmarNovalidados(
                    context, "Te faltan asociar estos documentos", listaEnvios);
              }
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Recibir', style: TextStyle(color: Colors.white)),
          ),
        ));

    Widget _crearListadoinMemoria() {
      return ListView.builder(
          itemCount: listaEnvios.length,
          itemBuilder: (context, i) => crearItem(listaEnvios[i]));
    }


    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
          _validarSobreText(value);
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

    contieneCodigo(codigo) {
      bool pertenecia = false;
      for (EnvioModel envio in listaEnvios) {
        if (envio.codigoPaquete == codigo) {
          pertenecia = true;
        }
      }
      if (pertenecia == true) {
        principalcontroller.recogerdocumento(
            context, codigo);
        listaEnvios.removeWhere((value) => value.codigoPaquete == codigo);
      } else {
        principalcontroller.recogerdocumento(
            context, codigo);
      }
    }

    Widget _validarListado(String codigo) {
      if (codigo == "") {
        return _crearListado();
      } else {
        contieneCodigo(codigo);
        return _crearListadoinMemoria();
      }
    }

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
          title: Text('Recepción valijas',
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
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    //width: double.infinity,
                    child: principalcontroller.labeltext("Documento")),
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
              Expanded(
                   child: Container(child: _validarListado(codigoSobre))),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 5),
                    width: double.infinity,
                    child: sendButton),
              ),
            ],
          ),
        ));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  void confirmarNovalidados(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    Widget informacion = principalcontroller.contenidoPopUp(
        colorletra, "La molina", novalidados.length);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: informacion,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Descartar pendientes'),
                  onPressed: () {
                    listaEnvios.clear();
                    _bandejaController.text = "";

                    _sobreController.text = "";
                    codigoSobre = "";
                    Navigator.of(context).pop();
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                  child: Text('Volver a leer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
