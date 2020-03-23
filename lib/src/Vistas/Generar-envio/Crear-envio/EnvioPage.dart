import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'EnvioController.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class EnvioPage extends StatefulWidget {
  /*final UsuarioFrecuente usuariopage;

  const EnvioPage({Key key, this.usuariopage}) : super(key: key);*/

  @override
  _EnvioPageState createState() => new _EnvioPageState(/*usuariopage*/);
}

class _EnvioPageState extends State<EnvioPage> {
  /*UsuarioFrecuente recordObject;
  _EnvioPageState(this.recordObject);*/
  final _formKey = GlobalKey<FormState>();
  EnvioController envioController = new EnvioController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  final _observacionController = TextEditingController();

  String qrsobre, qrbarra, valuess = "";
  String _name = '';
  String _label = '';
  int indice = 0;
  int indicebandeja = 0;
  @override
  void initState() {
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

  int nums = 10;

  bool validarenvio() {
    if (_sobreController.text.length == 0 ) {
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

    if (envioController.validarexistencia(_sobreController.text) &&
        envioController.validarexistenciabandeja(_bandejaController.text)) {
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
        margin: const EdgeInsets.only(top: 40),
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
                print("Realiza funcion del boton");
                
              }else{
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
    final observacion = TextField(
      maxLines: 6,
      controller: _observacionController,
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
    );

    var bandeja = TextFormField(
      enabled: false,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _bandejaController,
      onChanged: (text) {
        setState(() {
          if (text.length > 0 && text.length < 5) {
            indicebandeja = 2;
          }
          if (!envioController.validarexistencia(text)) {
            indicebandeja = 3;
          }
        });
      },
      validator: (String valuee) {
        if (valuee.isEmpty) {
          setState(() {
            indicebandeja = 1;
          });
          //return 'El campo se encuentra vacio';
        }
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

    var sobre = TextFormField(
      enabled: false,
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      onChanged: (text) {
        setState(() {
          if (text.length > 0 && text.length < 5) {
            indice = 2;
          }
          if (!envioController.validarexistencia(text)) {
            indice = 3;
          }
        });
      },
      validator: (String valuee) {
        if (valuee.isEmpty) {
          setState(() {
            indice = 1;
          });
          //return 'El campo se encuentra vacio';
        }
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
          leading: new IconButton(
            icon: new Icon(Icons.keyboard_arrow_left,
                color: Colors.white, size: 25),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
        backgroundColor: Colors.white,
        body: Form(
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
                          leading: Icon(Icons.perm_identity), //account_circle
                          title: Align(
                            child: new Text(
                                /*recordObject.nombre*/ "Katheleen Macedo",
                                style: TextStyle(fontSize: 15)),
                            alignment: Alignment(-1.2, 0),
                          ),
                        ),
                      ), //recordObject.area + " - " + recordObject.sede
                      ListTile(
                        leading: Icon(Icons.location_on), //account_circle
                        title: Align(
                          child: new Text(
                              /*recordObject.area + " - " + recordObject.sede*/ "Proyectos TI - Proyectos",
                              style: TextStyle(fontSize: 15)),
                          alignment: Alignment(-1.2, 0),
                        ),
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
                      errorsobre(_sobreController.text, indice),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 40,
                        child: ListTile(
                            title: new Text("Código de bandeja",
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
                      errorbandeja(_bandejaController.text, indicebandeja),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ListTile(
                            title: new Text("Observación",
                                style: TextStyle(fontSize: 15))),
                      ),
                      observacion,
                      sendButton
                    ]))));
  }
}
//                  Navigator.of(context).pushNamed(men.link);
