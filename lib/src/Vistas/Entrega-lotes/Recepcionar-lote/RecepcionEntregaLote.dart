import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/modals/confirmation.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/modals/confirmationArray.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'RecepcionController.dart';

class RecepcionEntregaLotePage extends StatefulWidget {
  final EntregaLoteModel entregaLotepage;

  const RecepcionEntregaLotePage({Key key, this.entregaLotepage})
      : super(key: key);

  @override
  _RecepcionEntregaLotePageState createState() =>
      new _RecepcionEntregaLotePageState(entregaLotepage);
}

class _RecepcionEntregaLotePageState extends State<RecepcionEntregaLotePage> {
  EntregaLoteModel entregaLote;
  _RecepcionEntregaLotePageState(this.entregaLote);
  RecepcionControllerLote principalcontroller = new RecepcionControllerLote();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  EnvioModel envioModel = new EnvioModel();
  List<EnvioModel> listaEnvios = new List();
  String qrsobre, qrbarra = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  var listadetinatario;
  var colorletra = const Color(0xFFACADAD);

  @override
  void initState() {
    if (entregaLote != null) {
      _bandejaController.text = entregaLote.paqueteId;
      codigoBandeja = entregaLote.paqueteId;
      iniciarlistaEnvios();
    } else {
      listaEnvios = [];
    }
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    super.initState();
  }

  void iniciarlistaEnvios() async {
    dynamic respuesta =
        await principalcontroller.listarEnviosLotes(codigoBandeja);
    setState(() {
      listaEnvios = envioModel.fromJsonValidar(respuesta["data"]);
    });
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    contieneCodigo(codigo) async {
      bool pertenecia = false;
      for (EnvioModel envio in listaEnvios) {
        if (envio.codigoPaquete == codigo) {
          pertenecia = true;
        }
      }
      if (pertenecia == true) {
        bool respuesta = await principalcontroller.recogerdocumentoLote(
            context, codigoBandeja, codigo);
        if (respuesta) {
          listaEnvios.removeWhere((value) => value.codigoPaquete == codigo);
          if (listaEnvios.isEmpty) {
            bool respuestatrue = await notificacion(
                context, "success", "EXACT", "Se ha completado la recepción");
            if (respuestatrue) {
              Navigator.of(context).pushNamed('/envio-lote');
            }
            setState(() {
              _sobreController.text = codigo;
              listaEnvios = listaEnvios;
            });
          } else {
            setState(() {
              _sobreController.text = codigo;
              listaEnvios = listaEnvios;
            });
            enfocarInputfx(context, f2);
          }
        } else {
          setState(() {
            _sobreController.text = codigo;
          });
          popuptoinput(context, f2, "error", "EXACT",
              "No es posible procesar el código");
        }
      } else {
        bool respuestaPopUp = await confirmacion(
            context, "success", "EXACT", "¿Desea custodiar el envío $codigo?");
        if (respuestaPopUp) {
          bool respuesta = await principalcontroller.recogerdocumentoLote(
              context, codigoBandeja, codigo);
          if (respuesta) {
            setState(() {
              _sobreController.text = codigo;
            });
            popuptoinput(
                context, f2, "success", "EXACT", "Se registró la valija");
          } else {
            setState(() {
              _sobreController.text = codigo;
            });
            popuptoinput(context, f2, "error", "EXACT",
                "No es posible procesar el código");
          }
        } else {
          enfocarInputfx(context, f2);
        }
      }
    }

    void _validarSobreText(String value) {
      desenfocarInputfx(context);
      if (value != "") {
        contieneCodigo(value);
      } else {
        popuptoinput(context, f2, "error", "EXACT",
            "El código de valija es obligatorio");
      }
    }

    void _validarBandejaText(String value) async {
      desenfocarInputfx(context);
      if (value != "") {
        dynamic respuesta = await principalcontroller.listarEnviosLotes(value);
        if (respuesta["status"] != "fail") {
          listaEnvios = envioModel.fromJsonValidar(respuesta["data"]);
          if(listaEnvios.isNotEmpty){
          setState(() {
            codigoBandeja = value;
            _bandejaController.text = value;
            listaEnvios = listaEnvios;
          });
          enfocarInputfx(context, f2);
          }else{
          setState(() {
            listaEnvios = [];
            _bandejaController.text = value;
          });
          popuptoinput(context, f1, "error", "EXACT", "No contiene envíos para recepcionar");
          }
        } else {
          setState(() {
            listaEnvios = [];
            _bandejaController.text = value;
          });
          popuptoinput(context, f1, "error", "EXACT", respuesta["message"]);
        }
      } else {
        setState(() {
          listaEnvios = [];
        });
        popuptoinput(context, f1, "error", "EXACT",
            "El campo del lote no puede estar vacío");
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
      qrbarra = await getDataFromCamera();
      if (codigoBandeja == "") {
        _sobreController.text = "";
        notificacion(context, "error", "EXACT",
            "Primero debe ingresar el codigo de la bandeja");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra = await getDataFromCamera();
      _validarBandejaText(qrbarra);
    }

    Widget sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              bool respuestaarray = await confirmarArray(context, "success",
                  "EXACT", "Te faltan asociar estos documentos", listaEnvios);
              if (respuestaarray == null) {
                Navigator.of(context).pop();
              } else {
                if (respuestaarray) {
                  bool respuestaTrue = await notificacion(context, "success",
                      "EXACT", "Se recepcionado correctamente las valijas");
                  if (respuestaTrue = !null) {
                    if (respuestaTrue) {
                      Navigator.of(context).pushNamed('/envio-lote');
                    }
                  }
                } else {
                  Navigator.of(context).pop();
                }
              }
            },
            color: Color(0xFF2C6983),
            child: Text('Terminar', style: TextStyle(color: Colors.white)),
          ),
        ));

    Widget _crearListadoinMemoria(List<EnvioModel> envios) {
      return ListView.builder(
          itemCount: envios.length,
          itemBuilder: (context, i) => crearItem(envios[i]));
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      focusNode: f1,
      autofocus: false,
      controller: _bandejaController,
      textInputAction: TextInputAction.next,
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
      focusNode: f2,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (codigoBandeja == "") {
          _sobreController.text = "";
          popuptoinput(context, f1, "error", "EXACT",
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
        appBar: CustomAppBar(text: "Recibir Lotes"),
        drawer: DrawerPage(),
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
                            child: principalcontroller
                                .labeltext("Código de lote")),
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
                            child: principalcontroller
                                .labeltext("Código de valija")),
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
                      Expanded(child: _validarListado(listaEnvios)),
                      listaEnvios.length != 0
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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }
}
