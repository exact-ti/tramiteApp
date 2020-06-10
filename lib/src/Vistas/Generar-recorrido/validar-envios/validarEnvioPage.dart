import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioController.dart';

class ValidacionEnvioPage extends StatefulWidget {
  final RecorridoModel recorridopage;
  const ValidacionEnvioPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _ValidacionEnvioPageState createState() =>
      _ValidacionEnvioPageState(recorridopage);
}

class _ValidacionEnvioPageState extends State<ValidacionEnvioPage> {
  RecorridoModel recorridoUsuario;
  _ValidacionEnvioPageState(this.recorridoUsuario);
  final _sobreController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  ValidacionController principalcontroller = new ValidacionController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, _label, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String textdestinatario = "";
  List<String> listaCodigosValidados = new List();
  bool inicio = true;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  var nuevo = 0;

  @override
  void initState() {
    prueba = Text("Usuarios frecuentes",
        style: TextStyle(fontSize: 15, color: Color(0xFFACADAD)));

    setState(() {
      codigoValidar = "";
      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);
    var booleancolor = true;
    var colorwidget = colorplomo;

    void _validarText(String value) {
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
            listaCodigosValidados.add(value);
            inicio = false;
          });
        } else {
          setState(() {
            _sobreController.text = "";
            codigoValidar = value;
            inicio = false;
          });
        }
      }
    }

    Future _traerdatosescanerbandeja() async {
      qrbarra = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarText(qrbarra);
    }

    listarNovalidados() {
      bool esvalidado = false;
      List<dynamic> as =  listaEnvios;
      List<dynamic> ads =  listaCodigosValidados;
      for (EnvioModel envio in listaEnvios) {
          if(listaCodigosValidados.contains(envio.codigoPaquete)){
              listaEnviosValidados.add(envio);
          }else{
            listaEnviosNoValidados.add(envio);
          }
      }
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
              listarNovalidados();
              if (listaEnviosNoValidados.length == 0) {
                principalcontroller.confirmacionDocumentosValidados(
                    listaEnviosValidados, context, recorridoUsuario.id);
              } else {
                confirmarNovalidados(
                    context,
                    "Te faltan asociar estos documentos",
                    listaEnviosNoValidados);
              }
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Continuar', style: TextStyle(color: Colors.white)),
          ),
        ));

    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _validarText(value);
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

    Widget crearItem(EnvioModel envio, List<String> validados) {
      int id = envio.id;
      String codigopaquete = envio.codigoPaquete;
      bool estado = false;
      if (validados.length != 0) {
        for (String codigovalidado in validados) {
          if (codigovalidado == envio.codigoPaquete) {
            estado = true;
          }
        }
      }
      agregaralista(envio);
      if (estado) {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading: FaIcon(FontAwesomeIcons.qrcode,color:Color(0xffC7C7C7)),
              trailing: Icon(
                Icons.check,
                color: Color(0xffC7C7C7),
              ),
            ));
      } else {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading: FaIcon(FontAwesomeIcons.qrcode,color:Color(0xffC7C7C7)),
              trailing: Text(""),
            ));
      }
    }

    Widget _crearListado(List<String> validados) {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller
              .validacionEnviosController(recorridoUsuario.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
              final envios = snapshot.data;
              return ListView.builder(
                  itemCount: envios.length,
                  itemBuilder: (context, i) => crearItem(envios[i], validados));
            } else {
              return Container();
            }
          });
    }

    Widget _crearListadoinMemoria(List<String> validados) {
      booleancolor = true;
      colorwidget = colorplomo;
      return ListView.builder(
          itemCount: listaEnvios.length,
          itemBuilder: (context, i) => crearItem(listaEnvios[i], validados));
    }

    Widget _crearListadoAgregar(
        List<String> validados, String codigoporValidar) {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.validarCodigo(
              codigoporValidar, recorridoUsuario.id, context),
          builder: (BuildContext context, AsyncSnapshot<EnvioModel> snapshot) {
            codigoValidar = "";
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
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

    Widget _validarListado(List<String> codigos, String codigo) {
      if (codigo == "") {
        if (inicio) {
          return _crearListado(codigos);
        } else {
          return _crearListadoinMemoria(codigos);
        }
      } else {
        return _crearListadoAgregar(codigos, codigo);
      }
    }

    final campodetextoandIcono = Row(children: <Widget>[
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
              onPressed: _traerdatosescanerbandeja),
        ),
      ),
    ]);

    const PrimaryColor = const Color(0xFF2C6983);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Entregas en sede',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        body:SingleChildScrollView(
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
                    alignment: Alignment.centerLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 6),
                    width: double.infinity,
                    child: campodetextoandIcono),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child:_validarListado(listaCodigosValidados, codigoValidar)),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 5),
                    width: double.infinity,
                    child: sendButton),
              ),
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

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  void _onSearchButtonPressed() {}

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  void confirmarNovalidados(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    List<Widget> listadecodigos = new List();

    for (EnvioModel codigo in novalidados) {
      String codigoPa = codigo.codigoPaquete;
      listadecodigos.add(Text('$codigoPa'));
    }

    showDialog(barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$titulo'),
            content: SingleChildScrollView(
              child: ListBody(children: listadecodigos),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Seguir sin estos documentos'),
                  onPressed: () {
                    listaEnviosNoValidados.clear();
                    principalcontroller.confirmacionDocumentosValidados(
                        listaEnviosValidados, context, recorridoUsuario.id);
                    listaEnviosValidados.clear();
                    listaEnvios.clear();
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                child: Text('Volver a leer'),
                onPressed: () {
                  listaEnviosNoValidados.clear();
                  listaEnviosValidados.clear();
                  Navigator.of(context).pop();
                } 
              )
            ],
          );
        });
  }
}
