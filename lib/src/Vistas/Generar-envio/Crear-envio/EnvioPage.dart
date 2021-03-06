import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'package:tramiteapp/src/styles/Icon_style.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
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
  int minvalor = 0;
  String errorSobre = "";
  String errorBandeja = "";
  FocusNode focusSobre = FocusNode();
  FocusNode focusBandeja = FocusNode();
  FocusNode focusObservacion = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => inicializarUsuario());
    minvalor = obtenerCantidadMinima();
    super.initState();
  }

  void inicializarUsuario() {
    if (this.mounted) {
      Map usuario = ModalRoute.of(context).settings.arguments;
      if (usuario != null) {
        UsuarioFrecuente usuarioFrecuente = new UsuarioFrecuente();
        usuarioFrecuente.area = usuario['area'];
        usuarioFrecuente.id = usuario['id'];
        usuarioFrecuente.nombre = usuario['nombre'];
        usuarioFrecuente.sede = usuario['sede'];
        setState(() {
          this.usuarioFrecuente = usuarioFrecuente;
        });
      }
    }
  }

  void validarEnvio() {
    envioController.crearEnvio(
        context,
        usuarioFrecuente.id,
        _sobreController.text,
        _bandejaController.text,
        _observacionController.text,
        usuarioFrecuente);
  }

  void onPressEnviarButton() {
    if (errorSobre.length == 0 &&
        errorBandeja.length == 0 &&
        _sobreController.text.length != 0) {
      desenfocarInputfx(context);
      validarEnvio();
    }
  }

  void enfocarCodigoBandeja(dynamic value) async {
    FocusScope.of(context).unfocus();
    new TextEditingController().clear();
    if (errorBandeja.length != 0) {
      popuptoinput(context, focusBandeja, "error", "EXACT", errorBandeja);
    } else {
      enfocarInputfx(context, focusObservacion);
    }
  }

  void evaluarBandeja(texto) async {
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
          _bandejaController.text = "";
        });
      }
    }
  }

  void enfocarCodigoBandejaByCamera(texto) async {
    if (texto.length >= obtenerCantidadMinima()) {
      bool respuestac = await envioController.validarexistenciabandeja(texto);
      if (!respuestac) {
        setState(() {
          errorBandeja = "No es posible procesar el código";
        });
        popuptoinput(context, focusBandeja, "error", "EXACT", errorBandeja);
      } else {
        setState(() {
          errorBandeja = "";
        });
        enfocarInputfx(context, focusObservacion);
      }
    } else {
      if (texto.length != 0) {
        setState(() {
          errorBandeja = "La longitud mínima es de $minvalor caracteres";
        });
        popuptoinput(context, focusBandeja, "error", "EXACT", errorBandeja);
      } else {
        setState(() {
          errorBandeja = "";
          _bandejaController.text = "";
        });

        enfocarInputfx(context, focusObservacion);
      }
    }
  }

  Future _traerdatosescanerbandeja() async {
    _bandejaController.text = await getDataFromCamera(context);
    setState(() {
      _bandejaController.text = _bandejaController.text;
    });
    enfocarCodigoBandejaByCamera(_bandejaController.text);
  }

  void enfocarcodigoSobre(dynamic texto) async {
    FocusScope.of(context).unfocus();
    if (errorSobre.length != 0) {
      popuptoinput(context, focusSobre, "error", "EXACT", errorSobre);
    } else {
      enfocarInputfx(context, focusBandeja);
    }
  }

  void evaluarSobre(dynamic texto) async {
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

  void enfocarcodigoSobreByCamera(String texto) async {
    if (texto.length == 0) {
      setState(() {
        errorSobre = "El código de sobre es obligatorio";
      });
      popuptoinput(context, focusSobre, "error", "EXACT", errorSobre);
    } else {
      if (texto.length >= obtenerCantidadMinima()) {
        bool respuestac = await envioController.validarexistenciaSobre(texto);
        if (!respuestac) {
          setState(() {
            errorSobre = "No es posible procesar el código";
          });
          popuptoinput(context, focusSobre, "error", "EXACT", errorSobre);
        } else {
          setState(() {
            errorSobre = "";
          });
          enfocarInputfx(context, focusBandeja);
        }
      } else {
        setState(() {
          errorSobre = "La longitud mínima es de $minvalor caracteres";
        });
        popuptoinput(context, focusSobre, "error", "EXACT", errorSobre);
      }
    }
  }

  Future _traerdatosescanersobre() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    enfocarcodigoSobreByCamera(_sobreController.text);
  }

  void onPressedObservacion(dynamic valueObservacion) {
    if (errorSobre.length == 0 &&
        errorBandeja.length == 0 &&
        _sobreController.text.length != 0) {
      validarEnvio();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget errorsobre(String contenido) {
      return Text(contenido,
          style: TextStyle(
              color: StylesThemeData.LETTER_ERROR_COLOR, fontSize: 15));
    }

    mainscaffold() {
      return Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: paddingWidget(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                Container(
                    margin:
                        const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            IconsData.ICON_USER,
                            size: StylesIconData.ICON_SIZE,
                            color: StylesThemeData.ICON_COLOR,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                                usuarioFrecuente == null
                                    ? ""
                                    : "Para: ${usuarioFrecuente.nombre}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: StylesThemeData.LETTER_COLOR)))
                      ],
                    )),
                Container(
                    margin:
                        const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            IconsData.ICON_LOCATION,
                            size: StylesIconData.ICON_SIZE,
                            color: StylesThemeData.ICON_COLOR,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                                usuarioFrecuente == null
                                    ? ""
                                    : "Área: " +
                                        usuarioFrecuente.area +
                                        " - " +
                                        usuarioFrecuente.sede,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: StylesThemeData.LETTER_COLOR)))
                      ],
                    )),
                InputWidget(
                    iconSufix: IconsData.ICON_CAMERA,
                    methodOnPressedSufix: _traerdatosescanersobre,
                    controller: _sobreController,
                    focusInput: focusSobre,
                    iconPrefix: IconsData.ICON_SOBRE,
                    methodOnChange: evaluarSobre,
                    methodOnPressed: enfocarcodigoSobre,
                    hinttext: "Código de sobre"),
                errorSobre.length == 0 ? Container() : errorsobre(errorSobre),
                InputWidget(
                    iconSufix: IconsData.ICON_CAMERA,
                    methodOnPressedSufix: _traerdatosescanerbandeja,
                    controller: _bandejaController,
                    focusInput: focusBandeja,
                    iconPrefix: IconsData.ICON_SOBRE,
                    methodOnChange: evaluarBandeja,
                    methodOnPressed: enfocarCodigoBandeja,
                    hinttext: "Código de bandeja (Opcional)"),
                errorBandeja.length == 0
                    ? Container()
                    : errorsobre(errorBandeja),
                Container(
                  child: InputWidget(
                      linesInput: 6,
                      controller: _observacionController,
                      focusInput: focusObservacion,
                      methodOnPressed: onPressedObservacion,
                      hinttext: "Observación (Opcional)"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ButtonWidget(
                        iconoButton: IconsData.ICON_SEND,
                        onPressed: onPressEnviarButton,
                        colorParam: errorSobre.length != 0 ||
                                errorBandeja.length != 0 ||
                                _sobreController.text.length == 0
                            ? StylesThemeData.BUTTON_DISABLE_COLOR
                            : StylesThemeData.BUTTON_PRIMARY_COLOR,
                        texto: "Enviar"))
              ]))));
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Generar envío"),
        drawer: drawerIfPerfil(),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }
}
