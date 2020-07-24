import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'NuevaEntregaExternaController.dart';

class NuevoEntregaExternaPage extends StatefulWidget {


  @override
  _NuevoEntregaExternaPageState createState() =>
      new _NuevoEntregaExternaPageState();
}

class _NuevoEntregaExternaPageState extends State<NuevoEntregaExternaPage> {
  final _sobreController = TextEditingController();
  final _bandejaController = TextEditingController();
  List<EnvioModel> listaEnvios = [];
  List<EnvioModel> listaEnviosValidados = [];
  List<EnvioModel> listaEnviosNoValidados = new List();
  NuevoEntregaExternaController principalcontroller = new NuevoEntregaExternaController();
  String qrsobre, qrbarra, valuess = "";
  var listadestinatarios;
  String codigoValidar = "";
  String codigoBandeja = "";
  String codigoSobre = "";
  int cantidadPendientes = 0;
  int cantidadInicial = 0;
  List<String> listaCodigosValidados = new List();
  bool inicio = true;
  var colorletra = const Color(0xFFACADAD);
  void initState() {
    super.initState();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const SecondColor = const Color(0xFF6698AE);

    listarNovalidados() {
      bool esvalidado = false;
      List<dynamic> as = listaEnvios;
      List<dynamic> ads = listaCodigosValidados;
      for (EnvioModel envio in listaEnvios) {
        if (listaCodigosValidados.contains(envio.codigoPaquete)) {
          listaEnviosValidados.add(envio);
        } else {
          listaEnviosNoValidados.add(envio);
        }
      }
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120, vertical: 10),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              listarNovalidados();
              if (listaEnviosNoValidados.length == 0) {
                principalcontroller.confirmacionDocumentosValidadosEntrega(
                    listaEnviosValidados,
                    context,
                    codigoBandeja);
              } else {
                confirmarNovalidados(
                    context,
                    "Te faltan asociar estos documentos",
                    listaEnviosNoValidados);
              }
            },
            color: Color(0xFF2C6983),
            child:
                Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));

    void _validarSobreText(String value) async{
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
            EnvioModel enviocontroller =  await principalcontroller.validarCodigoEntrega(_bandejaController.text,
              value,context);
            if(enviocontroller!=null){
                setState(() {
                  listaEnvios.add(enviocontroller);
                  listaCodigosValidados.add(value);
                });
            }
          /*setState(() {
            _sobreController.text = "";
            codigoSobre = value;
          });*/
        }
      }else{
        notificacion(
     context, "error", "EXACT", "El campo del sobre no puede ser vacío"); 
      }
    }

        void validarLista(String codigo) async {
      listaEnvios =
          await principalcontroller.listarEnviosEntrega(context, codigo);
      if (listaEnvios != null) {
        setState(() {
          codigoSobre = "";
          listaEnvios=listaEnvios;
          listaCodigosValidados.clear();
          _sobreController.text = "";
          codigoBandeja = codigo;
          _bandejaController.text = codigo;
        });
      } else {
        setState(() {
          listaCodigosValidados.clear();
          _sobreController.text = "";
                    codigoSobre = "";
          listaEnvios=[];
          codigoBandeja = codigo;
                    _bandejaController.text = codigo;

        });
      }
    }

    void _validarBandejaText(String value) {
      if (value != "") {
        validarLista(value);
      } else {
        notificacion(
     context, "error", "EXACT", "La bandeja es obligatoria"); 
                setState(() {
          listaEnvios.clear();
          listaCodigosValidados.clear();
          _sobreController.text = "";
                    codigoSobre = "";

        });
      }
    }

    final textBandeja = Container(
      child: Text("Valija"),
      margin: const EdgeInsets.only(left: 15),
    );

    final textSobre = Container(
      child: Text("Envío"),
      margin: const EdgeInsets.only(left: 15),
    );

    void agregaralista(EnvioModel envio) {
      bool pertenece = false;
      if (listaEnvios.length == 0) {
        listaEnvios.add(envio);
      } else {
        if (!listaEnvios.contains(envio)) {
          listaEnvios.add(envio);
        }
      }
    }

    Widget crearItem(EnvioModel envio, List<String> validados, int i) {
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
      if (i == 1) {
        agregaralista(envio);
      }
      if (estado) {
        return Container(
            decoration: myBoxDecoration(),
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: Text("$codigopaquete"),
              leading:
                  FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
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
              leading:
                  FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
              trailing: Text(""),
            ));
      }
    }

    Future _traerdatosescanerSobre() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      if (codigoBandeja == "") {
        _sobreController.text = "";
        notificacion(
     context, "error", "EXACT", "Primero debe ingresar el codigo de la bandeja"); 
      } else {
        _validarSobreText(qrbarra);
      }
    }

    Future _traerdatosescanerBandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      _validarBandejaText(qrbarra);
    }

    /*Widget pendientes(int cantidad) {
      int cantidadp = listaEnvios.length - listaCodigosValidados.length;
      if(cantidadp==0){
          cantidadp=cantidad;
      }
      if (cantidadp == 1) {
        return Text("Queda $cantidadp documento pendiente");
      }
      return Text("Quedan $cantidad documentos pendientes");
    }*/

    Widget _crearListado(List<String> validados) {
      return FutureBuilder(
          future: principalcontroller.listarEnviosEntrega(
              context, codigoBandeja),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {
            if (snapshot.hasData) {
              final envios = snapshot.data;
              return Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  /*Align(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomLeft,
                        height: screenHeightExcludingToolbar(context,
                            dividedBy: 30),
                        //width: double.infinity,
                        child: pendientes(envios.length)),
                  ),*/
                  Expanded(
                      child: ListView.builder(
                          itemCount: envios.length,
                          itemBuilder: (context, i) =>
                              crearItem(envios[i], validados, 1)))
                ],
              ));
            } else {
              return Container();
            }
          });
    }

    Widget _crearListadoinMemoria(List<String> validados, List<EnvioModel> envios) {
      return ListView.builder(
          itemCount: envios.length,
          itemBuilder: (context, i) => crearItem(envios[i], validados, 0));
    }

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
          notificacion(
     context, "error", "EXACT", "Primero debe ingresar el codigo de la bandeja"); 
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
          future: principalcontroller.validarCodigoEntrega(_bandejaController.text,
              codigoporValidar, context),
          builder: (BuildContext context, AsyncSnapshot<EnvioModel> snapshot) {
            codigoValidar = "";
            if (snapshot.hasData) {
              final envio = snapshot.data;
              listaEnvios.add(envio);
              validados.add(envio.codigoPaquete);
              return ListView.builder(
                  itemCount: listaEnvios.length,
                  itemBuilder: (context, i) =>
                      crearItem(listaEnvios[i], validados, 1));
            } else {
              if (listaEnvios.length != 0) {
                return ListView.builder(
                    itemCount: listaEnvios.length,
                    itemBuilder: (context, i) =>
                        crearItem(listaEnvios[i], validados, 1));
              } else {
                return Container();
              }
            }
          });
    }

    Widget _validarListado(List<String> validados, List<EnvioModel> envios) {
          return _crearListadoinMemoria(validados,envios);

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
          title: Text('Entregas externas',
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
                child:Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 50),
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
                  height: screenHeightExcludingToolbar(context, dividedBy: 12),
                  width: double.infinity,
                  child: campodetextoandIconoSobre,
                  margin: const EdgeInsets.only(bottom: 30),
                ),
              ),
              Expanded(
                  child: codigoBandeja == ""
                      ? Container()
                      : Container(
                          child: _validarListado(
                              listaCodigosValidados, listaEnvios))),
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

  void confirmarNovalidados(
      BuildContext context, String titulo, List<EnvioModel> novalidados) {
    List<Widget> listadecodigos = new List();

    for (EnvioModel codigo in novalidados) {
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
                  child: Text('Seguir sin estos documentos'),
                  onPressed: () {
                    principalcontroller.confirmacionDocumentosValidadosEntrega(
                        listaEnviosValidados,
                        context,
                        codigoBandeja);
                  }),
              SizedBox(height: 1.0, width: 5.0),
              FlatButton(
                  child: Text('Volver a leer'),
                  onPressed: () {
                    listaEnviosNoValidados.clear();
                    listaEnviosValidados.clear();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

}

//                  Navigator.of(context).pushNamed(men.link);
