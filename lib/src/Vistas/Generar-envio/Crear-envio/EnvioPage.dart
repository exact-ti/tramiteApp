import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/ConfiguracionModel.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'EnvioController.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class EnvioPage extends StatefulWidget {
  final UsuarioFrecuente usuariopage;

  const EnvioPage({Key key, this.usuariopage}) : super(key: key);

  @override
  _EnvioPageState createState() => new _EnvioPageState(usuariopage);
}

class _EnvioPageState extends State<EnvioPage> {
  UsuarioFrecuente recordObject;
  _EnvioPageState(this.recordObject);
  final _formKey = GlobalKey<FormState>();
  EnvioController envioController = new EnvioController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  final _observacionController = TextEditingController();
  var validarSobre = false;
  var validarBandeja = false;
  bool confirmaciondeenvio = false;
  String qrsobre, qrbarra, valuess = "";
  String _name = '';
  String _label = '';
  int indice = 0;
  int indicebandeja = 0;
  int minvalor = 0;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  final _prefs = new PreferenciasUsuario();
  ConfiguracionModel configuracionModel = new ConfiguracionModel();
  @override
  void initState() {
    List<dynamic> configuraciones = json.decode(_prefs.configuraciones);
    List<ConfiguracionModel> configuration =
        configuracionModel.fromPreferencs(configuraciones);
    for (ConfiguracionModel confi in configuration) {
      if (confi.nombre == "CARACTERES_MINIMOS_BUSQUEDA") {
        minvalor = int.parse(confi.valor);
      }
    }
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    valuess = "";
    super.initState();
  }

  Future _traerdatosescanersobre() async {
    qrsobre =
        await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
    setState(() {
      _sobreController.text = qrsobre;
      _label = qrsobre;
    });
  }

  Widget errorsobre(String rest, int numero, bool vali) {
    if (vali) {
      return Container();
    }

    if (rest.length == 0 && numero == 0) {
      return Container();
    }

    if (rest.length == 0 && numero != 0) {
      return respuesta("Es necesario ingresar el código del sobre");
    }

    if (rest.length > 0 && rest.length < minvalor) {
      return respuesta("La longitud mínima es de $minvalor caracteres");
    }

    return FutureBuilder(
        future: envioController.validarexistencia(rest),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            final validador = snapshot.data;
            if (!validador) {
              validarSobre = false;
              return respuesta("El código no existe");
            } else {
              validarSobre = true;
              return Container();
            }
          } else {
            return Container();
          }
        });

    //return Container();
  }

  Widget respuesta(String contenido) {
    return Text(contenido, style: TextStyle(color: Colors.red, fontSize: 15));
  }

  Widget errorbandeja(String rest, int numero, bool valie) {
    if (valie) {
      return Container();
    }

    if (rest.length == 0) {
      return Container();
    }

    if (rest.length == 0 && numero == 0) {
      return Container();
    }

    if (rest.length > 0 && rest.length < minvalor) {
      return respuesta("La longitud mínima es de $minvalor caracteres");
    }

    return FutureBuilder(
        future: envioController.validarexistenciabandeja(rest),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            final validador = snapshot.data;
            if (!validador) {
              validarBandeja = false;
              return respuesta("El código no existe");
            } else {
              validarBandeja = true;
              return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Future _traerdatosescanerbandeja() async {
    qrbarra =
        await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
    setState(() {
      _bandejaController.text = qrbarra;
      _label = qrbarra;
    });
  }

  Widget datosUsuarios(String text) {
    return ListTile(title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  Widget datosUsuariosArea(String text) {
    return ListTile(
        leading: Icon(Icons.location_on),
        title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  int nums = 5;

  bool validarenvio() {
    if (_sobreController.text.length == 0) {
      return false;
    }

    if (_sobreController.text.length > 0 &&
        _sobreController.text.length < nums) {
      return false;
    }

    if (_bandejaController.text.length > 0 &&
        _bandejaController.text.length < nums) {
      return false;
    }

    if (!validarSobre || !validarBandeja) {
      if (_bandejaController.text.length == 0) {
        return true;
      }
      return false;
    }

    return true;
  }

  var colorplomos = const Color(0xFFEAEFF2);
  bool inicio = false;
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8);
    const Colorplomo = const Color(0xFFEAEFF2);
    final sendButton = Container(
        margin: const EdgeInsets.only(top: 20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              indice = 1;
              indicebandeja = 1;
              if (_formKey.currentState.validate() && validarenvio()) {
/*                 setState(() {
                  confirmaciondeenvio = true;
                }); */
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
                envioController.crearEnvio(
                    context,
                    recordObject.id,
                    _sobreController.text,
                    _bandejaController.text,
                    _observacionController.text);
/*                 setState(() {
                  _sobreController.text = "";
                  _bandejaController.text = "";
                  _observacionController.text = "";
                  confirmaciondeenvio = false;
                  indice = 0;
                }); */
              } else {
                print("No se puede enviar");
              }
              //performLogin(context);
              //Navigator.of(context).pushNamed("principal");
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Enviar', style: TextStyle(color: Colors.white)),
          ),
        ));
    final observacion = TextFormField(
      maxLines: 6,
      controller: _observacionController,
      focusNode: f3,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEAEFF2),
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
      onFieldSubmitted: (value) async {
        if (_sobreController.text.length == 0) {
          bool respuestatrue = await notificacion(
              context, "error", "EXACT", "El código de sobre es obligatorio");
          if (respuestatrue == null || respuestatrue) {
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
            FocusScope.of(context).requestFocus(f1);
          }
        } else {
          indice = 1;
          indicebandeja = 1;
          if (_formKey.currentState.validate() && validarenvio()) {
            setState(() {
              confirmaciondeenvio = true;
            });
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
            envioController.crearEnvio(
                context,
                recordObject.id,
                _sobreController.text,
                _bandejaController.text,
                _observacionController.text);
            setState(() {
              _sobreController.text = "";
              _bandejaController.text = "";
              _observacionController.text = "";
              confirmaciondeenvio = false;
              indice = 0;
            });
          } else {
            print("No se puede enviar");
          }
        }
      },
    );



    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f2,
      controller: _bandejaController,
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        setState(() {
          if (text.length > 0 && text.length < 5) {
            indicebandeja = 2;
          }
          /*if (!envioController.validarexistencia(text)) {
            indicebandeja = 3;
          }*/
        });
      },
      onFieldSubmitted: (value) async {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        if (value.length == 0) {
            FocusScope.of(context).requestFocus(f3);
        } else {
          if (value.length > 0 && value.length < minvalor) {
            notificacion(context, "error", "EXACT",
                "La longitud mínima es de $minvalor caracteres");
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
            FocusScope.of(context).requestFocus(f2);
          } else {
            bool respuestac =
                await envioController.validarexistenciabandeja(value);
            if (respuestac) {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              FocusScope.of(context).requestFocus(f3);
            } else {
              notificacion(context, "error", "EXACT",
                  "No es posible procesar el código");
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              FocusScope.of(context).requestFocus(f2);
            }
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

    void validarcodigoSobre(String value) async {
      FocusScope.of(context).unfocus();
        if (value.length == 0) {
          bool respuestatrue = await notificacion(
              context, "error", "EXACT", "El código de sobre es obligatorio");
          if (respuestatrue == null || respuestatrue) {
            FocusScope.of(context).requestFocus(f1);
          }
        } else {
          if (value.length > 0 && value.length < minvalor) {
            bool respuestatrue = await notificacion(context, "error", "EXACT",
                "La longitud mínima es de $minvalor caracteres");
            if (respuestatrue == null || respuestatrue) {
              FocusScope.of(context).requestFocus(f1);
            }
          } else {
            bool respuestac = await envioController.validarexistencia(value);
            if (respuestac) {
              FocusScope.of(context).requestFocus(f2);
            } else {
              notificacion(context, "error", "EXACT",
                  "No es posible procesar el código");
              FocusScope.of(context).requestFocus(f1);
            }
          }
        }
    }


    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      focusNode: f1,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) async {
        FocusScope.of(context).unfocus();
        if (value.length == 0) {
          bool respuestatrue = await notificacion(
              context, "error", "EXACT", "El código de sobre es obligatorio");
          if (respuestatrue == null || respuestatrue) {
            FocusScope.of(context).requestFocus(f1);
          }
        } else {
          if (value.length > 0 && value.length < minvalor) {
            bool respuestatrue = await notificacion(context, "error", "EXACT",
                "La longitud mínima es de $minvalor caracteres");
            if (respuestatrue == null || respuestatrue) {
              FocusScope.of(context).requestFocus(f1);
            }
          } else {
            bool respuestac = await envioController.validarexistencia(value);
            if (respuestac) {
              FocusScope.of(context).requestFocus(f2);
            } else {
              notificacion(context, "error", "EXACT",
                  "No es posible procesar el código");
              FocusScope.of(context).requestFocus(f1);
            }
          }
        }
      },
      onChanged: (text) {
        setState(() {
          if (text.length > 0 && text.length < 5) {
            indice = 2;
          }
          //_sobreController.text=text;
          /*if (!envioController.validarexistencia(text)) {
            indice = 3;
          }*/
        });
      },
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        //labelText: _label,
        //labelStyle: new TextStyle(color: Color(0xFF000000), fontSize: 16.0),
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Generar envío',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                height: 35,
                                child: ListTile(
                                  leading: Icon(
                                      Icons.perm_identity), //account_circle
                                  title:
                                      /* Align(
                            child: */
                                      new Text(recordObject.nombre,
                                          style: TextStyle(fontSize: 15)),
                                  //alignment: Alignment(-1.2, 0),
                                  /*),*/
                                ),
                              ), //recordObject.area + " - " + recordObject.sede
                              ListTile(
                                leading:
                                    Icon(Icons.location_on), //account_circle
                                title:
                                    /*Align(
                          child:*/
                                    new Text(
                                        recordObject.area +
                                            " - " +
                                            recordObject.sede,
                                        style: TextStyle(fontSize: 15)),
                                //   alignment: Alignment(-1.2, 0),
                                /*),*/
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: 40,
                                child: ListTile(
                                    title: new Text("Código de sobre",
                                        style: TextStyle(fontSize: 15))),
                              ),
                              Row(children: <Widget>[
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
                                        onPressed: _traerdatosescanersobre),
                                  ),
                                ),
                              ]),
                              errorsobre(_sobreController.text, indice,
                                  confirmaciondeenvio),
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: 40,
                                child: ListTile(
                                    title: new Text(
                                        "Código de bandeja (Opcional)",
                                        style: TextStyle(fontSize: 15))),
                              ),
                              Row(children: <Widget>[
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
                                        onPressed: _traerdatosescanerbandeja),
                                  ),
                                ),
                              ]),
                              errorbandeja(_bandejaController.text,
                                  indicebandeja, confirmaciondeenvio),
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: ListTile(
                                    title: new Text("Observación (Opcional)",
                                        style: TextStyle(fontSize: 15))),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 0),
                                child: observacion,
                              ),
                              sendButton
                            ]))))));
  }
}
//                  Navigator.of(context).pushNamed(men.link);
