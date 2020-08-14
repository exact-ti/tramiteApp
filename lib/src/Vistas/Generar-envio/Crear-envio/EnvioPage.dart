import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'EnvioController.dart';

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
  int indice = 0;
  int indicebandeja = 0;
  int minvalor = 0;
  String errorSobre = "";
  String errorBandeja = "";
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  @override
  void initState() {
    minvalor = obtenerCantidadMinima();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    valuess = "";
    super.initState();
  }

  Widget errorsobre(String contenido) {
    return Text(contenido, style: TextStyle(color: Colors.red, fontSize: 15));
  }

  Widget respuesta(String contenido) {
    return Text(contenido, style: TextStyle(color: Colors.red, fontSize: 15));
  }

  Widget datosUsuarios(String text) {
    return ListTile(title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  Widget datosUsuariosArea(String text) {
    return ListTile(
        leading: Icon(Icons.location_on),
        title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    void validarEnvio() {
      envioController.crearEnvio(
          context,
          recordObject.id,
          _sobreController.text,
          _bandejaController.text,
          _observacionController.text);
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              if (errorSobre.length == 0 &&
                  errorBandeja.length == 0 &&
                  _sobreController.text.length != 0) {
                validarEnvio();
              }
            },
            color: errorSobre.length != 0 ||
                    errorBandeja.length != 0 ||
                    _sobreController.text.length == 0
                ? Colors.grey
                : Color(0xFF2C6983),
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
        if (errorSobre.length == 0 &&
            errorBandeja.length == 0 &&
            _sobreController.text.length != 0) {
          validarEnvio();
        }
      },
    );

    void enfocarCodigoBandeja() async {
      FocusScope.of(context).unfocus();
      new TextEditingController().clear();
      if (errorBandeja.length != 0) {
        popuptoinput(context, f2, "error", "EXACT", errorBandeja);
      } else {
        enfocarInputfx(context, f3);
      }
    }

    evaluarBandeja(texto) async {
      if (texto.length >= obtenerCantidadMinima()) {
        bool respuestac = await envioController.validarexistenciabandeja(texto);
        if (!respuestac) {
          setState(() {
            errorBandeja = "No es posible procesar el código";
          });
        } else {
          setState(() {
            errorBandeja = "";
          });
        }
      } else {
        if (texto.length != 0) {
          setState(() {
            errorBandeja = "La longitud mínima es de $minvalor caracteres";
          });
        } else {
          setState(() {
            errorBandeja = "";
          });
        }
      }
    }

    Future _traerdatosescanerbandeja() async {
      qrbarra = await getDataFromCamera();
      setState(() {
        _bandejaController.text = qrbarra;
      });
      await evaluarBandeja(qrbarra);
      enfocarCodigoBandeja();
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: f2,
      controller: _bandejaController,
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        evaluarBandeja(text);
      },
      onFieldSubmitted: (value) async {
        enfocarCodigoBandeja();
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

    void enfocarcodigoSobre() async {
      FocusScope.of(context).unfocus();
      if (errorSobre.length != 0) {
        popuptoinput(context, f1, "error", "EXACT", errorSobre);
      } else {
        enfocarInputfx(context, f2);
      }
    }

    void evaluarSobre(String texto) async {
      if (texto.length == 0) {
        setState(() {
          errorSobre = "El código de sobre es obligatorio";
        });
      } else {
        if (texto.length >= obtenerCantidadMinima()) {
          bool respuestac = await envioController.validarexistenciaSobre(texto);
          if (!respuestac) {
            setState(() {
              errorSobre = "No es posible procesar el código";
            });
          } else {
            setState(() {
              errorSobre = "";
            });
          }
        } else {
          setState(() {
            errorSobre = "La longitud mínima es de $minvalor caracteres";
          });
        }
      }
    }

    Future _traerdatosescanersobre() async {
      qrsobre = await getDataFromCamera();
      setState(() {
        _sobreController.text = qrsobre;
      });
      await evaluarSobre(qrsobre);
      enfocarcodigoSobre();
    }

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      focusNode: f1,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) async {
        enfocarcodigoSobre();
      },
      onChanged: (text) {
        evaluarSobre(text);
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
                                  leading: Icon(Icons.perm_identity),
                                  title: new Text("Para: "+recordObject.nombre,
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: new Text("Área: "+
                                    recordObject.area +
                                        " - " +
                                        recordObject.sede,
                                    style: TextStyle(fontSize: 15)),
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
                              errorSobre.length == 0
                                  ? Container()
                                  : errorsobre(errorSobre),
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
                              errorBandeja.length == 0
                                  ? Container()
                                  : errorsobre(errorBandeja),
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
