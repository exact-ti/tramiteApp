import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoController.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';

class CustodiaExternoPage extends StatefulWidget {
  @override
  _CustodiaExternoPageState createState() => new _CustodiaExternoPageState();
}

class _CustodiaExternoPageState extends State<CustodiaExternoPage> {
  CustodiaController custodiaController = new CustodiaController();

  final subtituloStyle = TextStyle(color: sd.colorletra);

  final tituloMensaje = 'Custodiar envíos';

  var booleancolor = true;

  var colorwidget = sd.colorplomo;

  var contenido;

  var txtCodigoPaquete;

  var codigoPaqueteCamara = "";

  var codigoPaquete = "";

  List<PaqueteExterno> creados = new List<PaqueteExterno>();

  final _codigoController = TextEditingController();

  var colorletra = const Color(0xFFACADAD);

  String txtcodigo = "";
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(text: "Custodiar envíos"),
        drawer: DrawerPage(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top),
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[_subtitulo(), _crearListado()],
                ),
              )),
        )));
  }

  Widget _subtitulo() {
    this.txtCodigoPaquete = _generarControlCodigoPaquete();

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          alignment: Alignment.centerLeft,
          height: sd.screenHeightExcludingToolbar(context, dividedBy: 6),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: this.txtCodigoPaquete,
                flex: 5,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: new IconButton(
                      icon: Icon(Icons.camera_alt),
                      tooltip: "Increment",
                      onPressed: _custodiarConCamara),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _generarControlCodigoPaquete() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
/*       focusNode: f1,
 */      controller: _codigoController,
      onFieldSubmitted: (text) {
        // if (text.length > 5){

        setState(() {
          this.codigoPaquete = text;
          _codigoController.text = text;
        });
        _custodiarPaquete();

        // }
      },
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.description),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 11.0, horizontal: 10.0),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        // hintText: 'Código de documento'
      ),
    );
  }

  Widget _crearListado() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
            future: _listarCreados(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PaqueteExterno>> snapshot) {
                              switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor");
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados("Ha surgido un problema");
                } else {
                  if (snapshot.hasData) {
                    booleancolor = true;
                    this.creados = snapshot.data;
                    if (this.creados.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: this.creados.length,
                          itemBuilder: (context, i) => _crearItem(this.creados[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
            }),
      ),
    );
  }

  Widget _crearItem(PaqueteExterno paquete) {
    return Container(
      decoration: myBoxDecoration(),
      margin: EdgeInsets.only(bottom: 5),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15),
            child: new IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: Colors.grey,
                ),
                onPressed: sd.getDataFromCamera),
          ),
        ),
        Expanded(
          child: informacionPaquete(paquete),
          flex: 5,
        ),
      ]),
    );
  }

  Widget informacionPaquete(PaqueteExterno p) {
    return Container(
      height: 50,
      child: Container(
        height: 20,
        child: ListTile(title: Text(p.paqueteId)),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  Future<List<PaqueteExterno>> _listarCreados() async {
    List<PaqueteExterno> paqueteList =
        await custodiaController.listarPaquetesExternosCreados();
    return paqueteList;
  }

  void _custodiarPaquete() async {
    var codigo = this.codigoPaquete;

    if (codigo == "") {
      notificacion(context, "error", "EXACT",
          'Ingrese el código de paquete para custodiar el envío');
      return;
    }

    if (this.creados.length == 0) {
      notificacion(
          context, "error", "EXACT", 'No existen envíos para custodiar');
      return;
    }

    //validar

    bool existeEnvio = _validarCodigo(codigo);

    if (existeEnvio == false) {
      popuptoinput(context, f1, "error", "EXACT",
          "El código ingresado no se encuentra en la lista de envíos por custodiar");
      return;
    }

    //custodiar
    PaqueteExterno paq = new PaqueteExterno();
    paq.paqueteId = codigo;
    bool resp = await custodiaController.custodiarPaquete(paq);

    if (resp) {
      setState(() {
        this.codigoPaquete = "";
        _codigoController.text = "";
      });
      enfocarInputfx(context, f1);
      _crearListado();
    } else {
      popuptoinput(context, f1, "error", "EXACT",
          "No se pudo custodiar el paquete con código $codigo");
    }

    this.codigoPaquete = "";
    //listar
  }

  bool _validarCodigo(String codigo) {
    bool existeEnvio = false;
    for (var item in this.creados) {
      if (item.paqueteId == codigo) {
        existeEnvio = true;
        break;
      }
    }
    return existeEnvio;
  }

  void _custodiarConCamara() async {
    var codigo = await sd.getDataFromCamera();

    this.codigoPaqueteCamara = codigo;

    if (codigo == "") {
      return;
    }

    bool existeEnvio = _validarCodigo(codigo);

    if (existeEnvio == false) {
      popuptoinput(
          context, f1, "error", "EXACT", "El código no pertenece a la lista");
      return;
    }

    PaqueteExterno paq = new PaqueteExterno();

    paq.paqueteId = codigo;

    bool resp = await custodiaController.custodiarPaquete(paq);

    if (resp) {
      setState(() {
        this.codigoPaquete = "";
        _codigoController.text = "";
      });
      enfocarInputfx(context, f1);
      _crearListado();
    } else {
      popuptoinput(context, f1, "error", "EXACT",
          "No se pudo custodiar el paquete con código $codigo");
    }
  }
}
