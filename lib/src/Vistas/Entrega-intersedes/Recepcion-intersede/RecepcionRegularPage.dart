import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Vistas/Entrega-intersedes/Nueva-intersede/EntregaInterController.dart';
import 'RecepcionRegularController.dart';

class RecepcionInterPage extends StatefulWidget {
  final EnvioInterSedeModel recorridopage;

  const RecepcionInterPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _RecepcionInterPageState createState() =>
      new _RecepcionInterPageState(recorridopage);
}

class _RecepcionInterPageState extends State<RecepcionInterPage> {
  EnvioInterSedeModel recorridoUsuario;
  _RecepcionInterPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  //final _sobreController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  EntregaregularController entregaController = new EntregaregularController();
  RecepcionInterController principalcontroller = new RecepcionInterController();
  //EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  String textdestinatario = "";
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

  mostrarenviosiniciales() async {
    listaEnvios = await principalcontroller.listarEnvios(
        context, _bandejaController.text);

    if (listaEnvios != null) {
      if (listaEnvios.length == 0) {
        setState(() {
          listaEnvios = [];
        });
      } else {
        setState(() {
          listaEnvios = listaEnvios;
        });
      }
    } else {
      setState(() {
        listaEnvios = [];
      });
    }
  }

  @override
  void initState() {
    valuess = "";
    if (recorridoUsuario != null) {
      _bandejaController.text = recorridoUsuario.codigo;
      codigoBandeja = recorridoUsuario.codigo;
      mostrarenviosiniciales();
    }
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              if (listaEnvios.length > 0) {
                confirmarNovalidados(
                    context, "Faltan los siguientes elementos a validar");
              } else {
                codigoBandeja = "";
                bool respuestatrue = await notificacion(context, "success", "EXACT",
                    "Se ha completado con la recepción de documentos");
                if (respuestatrue) {
                  Navigator.of(context).pushNamed('/envio-intersede');
                }
              }
            },
            color: Color(0xFF2C6983),
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Terminar', style: TextStyle(color: Colors.white)),
          ),
        ));

    void _validarSobreText(String value) async {
      if (value != "") {
        bool perteneceLista = false;
        for (EnvioModel envio in listaEnvios) {
          if (envio.codigoPaquete == value) {
            perteneceLista = true;
          }
        }
        if (perteneceLista) {
          dynamic respuestaValidar = await principalcontroller.recogerdocumento(
              context, _bandejaController.text, value, true);
          if (respuestaValidar["status"] == "success") {
            listaEnvios.removeWhere((envio) => envio.codigoPaquete == value);
            if (listaEnvios.length == 0) {
              bool respuestatrue = await notificacion(context, "success", "EXACT",
                  "Se ha recepcionado los documentos con éxito");
              if (respuestatrue) {
                Navigator.of(context).pushNamed('/envio-intersede');
              }
            }
            setState(() {
              listaEnvios = listaEnvios;
            });
          } else {
            notificacion(
                context, "error", "EXACT", "No es posible procesar el código");
          }
        } else {
          dynamic respuestaValidar = await principalcontroller.recogerdocumento(
              context, _bandejaController.text, value, true);
          if (respuestaValidar["status"] != "success") {
          } else {
            notificacion(
                context, "success", "EXACT", "Se ha registrado el envío");
          }
        }
      }
    }

    void _validarBandejaText(String value) async {
      if (value != "") {
        listaEnvios = await principalcontroller.listarEnvios(context, value);
        if (listaEnvios != null) {
          if (listaEnvios.length != 0) {
            setState(() {
              _bandejaController.text = value;
              listaEnvios = listaEnvios;
            });
          } else {
            notificacion(
                context, "error", "EXACT", "No es posible procesar el código");
            setState(() {
              listaEnvios = [];
            });
          }
        } else {
          notificacion(
              context, "error", "EXACT", "No es posible procesar el código");
          setState(() {
            listaEnvios = [];
          });
        }
      }
    }

    final textBandeja = Container(
      child: Text("Código de valija"),
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
        notificacion(context, "error", "EXACT",
            "Primero debe ingresar el codigo de la valija");
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
          future: principalcontroller.listarEnvios(context, codigoBandeja),
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

    Widget _crearListadoinMemoria(List<EnvioModel> envios) {
      return ListView.builder(
          itemCount: listaEnvios.length,
          itemBuilder: (context, i) => crearItem(listaEnvios[i]));
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
          notificacion(context, "error", "EXACT",
              "Primero debe ingresar el codigo de la bandeja");
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

    Widget _validarListado(List<EnvioModel> envios) {
      return _crearListadoinMemoria(envios);
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Recibir Valijas',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            width: double.infinity,
                            child: textBandeja),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 12),
                            width: double.infinity,
                            child: campodetextoandIconoBandeja),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 30),
                            //width: double.infinity,
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
                          child:
                              Container(child: _validarListado(listaEnvios))),
                      listaEnvios.length > 0
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeightExcludingToolbar(context,
                                      dividedBy: 5),
                                  width: double.infinity,
                                  child: sendButton),
                            )
                          : Container(),
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

  void confirmarNovalidados(BuildContext context, String titulo) {
    List<Widget> listadecodigos = new List();

    for (EnvioModel codigo in listaEnvios) {
      String codigoPa = codigo.codigoPaquete;
      listadecodigos.add(Text('$codigoPa'));
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: ListBody(children: listadecodigos),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Registrar de todos modos'),
                  onPressed: () async {
                    codigoBandeja = "";
                    bool respuestatrue = await notificacion(context, "success",
                        "EXACT", "Se ha recepcionado los documentos con éxito");
                    if (respuestatrue) {
                      Navigator.of(context).pushNamed('/envio-intersede');
                    }
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                  child: Text('Volver y seguir validando'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
//                  Navigator.of(context).pushNamed(men.link);
