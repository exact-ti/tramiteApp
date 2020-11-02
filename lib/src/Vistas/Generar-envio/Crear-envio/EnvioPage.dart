import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/widgets/testFormUppCase.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'EnvioController.dart';

class EnvioPage extends StatefulWidget {
  final UsuarioFrecuente usuariopage;

  const EnvioPage({Key key, this.usuariopage}) : super(key: key);

  @override
  _EnvioPageState createState() => new _EnvioPageState(usuariopage);
}

class _EnvioPageState extends State<EnvioPage> {
  UsuarioFrecuente usuarioFrecuente;
  _EnvioPageState(this.usuarioFrecuente);
  final _formKey = GlobalKey<FormState>();
  EnvioController envioController = new EnvioController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  final _observacionController = TextEditingController();
  String qrsobre, qrbarra = "";
  int minvalor = 0;
  String errorSobre = "";
  String errorBandeja = "";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();

  @override
  void initState() {
    minvalor = obtenerCantidadMinima();
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
    void validarEnvio() {
      envioController.crearEnvio(
          context,
          usuarioFrecuente.id,
          _sobreController.text,
          _bandejaController.text,
          _observacionController.text);
    }

    final sendButton = Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        alignment: Alignment.center,
        child: ButtonTheme(
          minWidth: 150.0,
          height: 50.0,
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
              child: Text('Enviar', style: TextStyle(color: Colors.white))),
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
      qrbarra = await getDataFromCamera(context);
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
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
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
      qrsobre = await getDataFromCamera(context);
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

    mainscaffold() {
      return Form(
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
                        title: new Text("Para: " + usuarioFrecuente.nombre,
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: new Text(
                          "Área: " +
                              usuarioFrecuente.area +
                              " - " +
                              usuarioFrecuente.sede,
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
                          title: new Text("Código de bandeja (Opcional)",
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
                  ])));
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Generar envío"),
        drawer: drawerIfPerfil(),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }
}
