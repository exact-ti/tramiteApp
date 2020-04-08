import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioInterSede.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'EntregaRegularController.dart';

class NuevoIntersedePage extends StatefulWidget {
  final EnvioInterSedeModel envioInterSede;

  const NuevoIntersedePage({Key key, this.envioInterSede}) : super(key: key);

  @override
  _NuevoIntersedePageState createState() =>
      new _NuevoIntersedePageState(envioInterSede);
}

class _NuevoIntersedePageState extends State<NuevoIntersedePage> {
  EnvioInterSedeModel intersedeModel;
  _NuevoIntersedePageState(this.intersedeModel);
  EntregaregularController envioController = new EntregaregularController();
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  //final _sobreController = TextEditingController();
  List<EnvioModel> listaEnvios = new List();
  List<EnvioModel> listaEnviosValidados = new List();
  List<EnvioModel> listaEnviosNoValidados = new List();
  EntregaregularController principalcontroller = new EntregaregularController();
  //EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra, _label, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  String textdestinatario = "";
  int cantidadPendientes = 0;
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
  int indice = 0;
  int indicebandeja = 0;
  @override
  void initState() {
    valuess = "";
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

      String destino = intersedeModel.destino ;
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

    final sendButton = Container(
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
                principalcontroller.confirmacionDocumentosValidados(intersedeModel,
                    listaEnviosValidados, context, intersedeModel.id);
              } else {
                confirmarNovalidados(
                    context,
                    "Te faltan asociar estos documentos",
                    listaEnviosNoValidados);
              }
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Nueva Valija', style: TextStyle(color: Colors.white)),
          ),
        ));

    void _validarSobreText(String value) {
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
            codigoSobre = value;
            listaCodigosValidados.add(value);
          });
        } else {
          setState(() {
            _sobreController.text = "";
            codigoSobre = value;
          });
        }
      }
    }

    void _validarBandejaText(String value) {
      if (value != "") {
        setState(() {
          codigoBandeja = value;
          _bandejaController.text = "";
        });
      }
    }


    final textBandeja = Container(
      child: Text("Valija"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Código"),
      margin: const EdgeInsets.only(left: 15),
    );

    void agregaralista(EnvioModel envio) {
      bool pertenece = false;
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {

         if(!listaEnvios.contains(envio)){
            listaEnvios.add(envio);
         } 

/*
        for (EnvioModel envioModel in listaEnvios) {
          if (envioModel.id == envio.id) {
            pertenece = true;
          }
        }
        if (!pertenece) {
          listaEnvios.add(envio);
        }*/
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

    Future _traerdatosescanerSobre() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (codigoBandeja == "") {
        _sobreController.text = "";
        mostrarAlerta(context, "Primero debe ingresar el codigo de la bandeja",
            "Ingreso incorrecto");
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarBandejaText(qrbarra);
    }


    Widget _crearListado(List<String> validados) {
      return FutureBuilder(
          future: principalcontroller.listarEnvios(context,
              intersedeModel, codigoBandeja),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            if (snapshot.hasData) {
              final envios = snapshot.data;
              cantidadPendientes=envios.length;
              return ListView.builder(
                  itemCount: envios.length,
                  itemBuilder: (context, i) => crearItem(envios[i],validados));
            } else {
              return Container();
            }
          });
    }

    Widget _crearListadoinMemoria(List<String> validados) {
      return ListView.builder(
          itemCount: listaEnvios.length,
          itemBuilder: (context, i) => crearItem(listaEnvios[i],validados));
    }

    final textoPendientes = Text("Quedan $cantidadPendientes documentos pendientes");

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
          mostrarAlerta(
              context,
              "Primero debe ingresar el codigo de la bandeja",
              "Ingreso incorrecto");
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

      Widget _crearListadoAgregar(
        List<String> validados, String codigoporValidar) {

      return FutureBuilder(
          future: principalcontroller.validarCodigo(
              codigoporValidar, intersedeModel.id, context),
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

    Widget _validarListado(List<String> validados,String codigo) {
      if (codigo == "") {
        return _crearListado(validados);
      } else {
        if (validados.contains(codigo)) {
          return _crearListadoinMemoria(validados);
        } else {
          return _crearListadoAgregar(validados, codigo);
        }
      }
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
          title: Text('Agregar valija a la $destino',
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
                    width: double.infinity,
                    child: textBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    //width: double.infinity,
                    child: textSobre),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoSobre,
                    margin: const EdgeInsets.only(bottom: 40),),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: cantidadPendientes == 0
                      ? Container(): Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    //width: double.infinity,
                    child: textoPendientes),
              ),              
              Expanded(
                  child: codigoBandeja == ""
                      ? Container()
                      : Container(
                          child: _validarListado(listaCodigosValidados,codigoSobre))),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 8),
                    width: double.infinity,
                    child: sendButton),
              ),
            ],
          ),
        ));
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

   void confirmarNovalidados(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    List<Widget> listadecodigos = new List();

    for (EnvioModel codigo in novalidados) {
      String codigoPa = codigo.codigoPaquete;
      listadecodigos.add(Text('$codigoPa'));
    }

    showDialog(
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
                    principalcontroller.confirmacionDocumentosValidados(intersedeModel,
                        listaEnviosValidados, context, intersedeModel.id);
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

//                  Navigator.of(context).pushNamed(men.link);
