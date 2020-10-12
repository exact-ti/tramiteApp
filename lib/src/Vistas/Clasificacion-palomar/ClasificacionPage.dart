
import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'ClasificacionController.dart';

class ClasificacionPage extends StatefulWidget {
  @override
  _ClasificacionPageState createState() => _ClasificacionPageState();
}

class _ClasificacionPageState extends State<ClasificacionPage> {
  ClasificacionController principalcontroller = new ClasificacionController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();
  String qrsobre, qrbarra,valuess = "";
  String codigoValidar = "";
  final _sobreController = TextEditingController();
  var listadestinatarios;
  String textdestinatario = "";
  List<PalomarModel> listapalomar = [];
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  var nuevo = 0;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _sobreController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _validarText(String value) async {
    desenfocarInputfx(context);
      listapalomar =await principalcontroller.listarpalomarByCodigo(context, value);
      if (listapalomar.length != 0) {
        setState(() {
          _sobreController.text = value;
          codigoValidar = value;
          listapalomar = listapalomar;
        });
        desenfocarInputfx(context);
      } else {
        setState(() {
          _sobreController.text = value;
          codigoValidar = value;
          listapalomar = [];
        });
        popuptoinput(context, f1, "error", "EXACT",
            "El sobre no existe en la base de datos");
      }
    }

    Widget crearItem(PalomarModel palomar) {
      String codigopalomar = palomar.id;
      String tipo = palomar.tipo;
      String ubicacion = palomar.ubicacion;
      return Container(
          child: new Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: Text('Palomar',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('$codigopalomar',
                        style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child:
                          Text('Tipo', style: TextStyle(color: Colors.black)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('$tipo', style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Ubicación',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('$ubicacion',
                        style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              ))
        ],
      ));
    }
    var sobre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _sobreController,
      textInputAction: TextInputAction.done,
      textAlign: TextAlign.center,
      focusNode: f1,
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
        hintText: 'Ingrese codigo',
      ),
    );

    Future _traerdatosescanerbandeja() async {
      qrbarra = await getDataFromCamera();
      desenfocarInputfx(context);
      _validarText(qrbarra);
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

    Widget _crearcontenido(List<PalomarModel> lista) {
      if (lista.length == 0) {
        return Container();
      } else {
        return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) => crearItem(lista[i]));
      }
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Clasificar envios"),
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
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: const EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 10),
                            width: double.infinity,
                            child: campodetextoandIcono),
                      ),
                      Expanded(
                        child: _sobreController.text == ""
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(top: 20),
                                alignment: Alignment.bottomCenter,
                                child: _crearcontenido(listapalomar)),
                      )
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
}
