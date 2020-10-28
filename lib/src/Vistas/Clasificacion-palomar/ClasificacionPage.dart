import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/InputCamera.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'ClasificacionController.dart';

class ClasificacionPage extends StatefulWidget {
  @override
  _ClasificacionPageState createState() => _ClasificacionPageState();
}

class _ClasificacionPageState extends State<ClasificacionPage> {
  ClasificacionController principalcontroller = new ClasificacionController();
  final _sobreController = TextEditingController();
  List<PalomarModel> listapalomar = [];
  FocusNode f1 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _validarText() async {
    String value = _sobreController.text;
    desenfocarInputfx(context);
    listapalomar = await principalcontroller.listarpalomarByCodigo(context, value);
    if (listapalomar.isNotEmpty) {
      setState(() {
        _sobreController.text = value;
        listapalomar = listapalomar;
      });
    } else {
      setState(() {
        _sobreController.text = value;
        listapalomar = [];
      });
      popuptoinput(context, f1, "error", "EXACT",
          "El sobre no existe en la base de datos");
    }
  }

  Future _traerdatosescanerbandeja() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarText();
  }

  @override
  Widget build(BuildContext context) {

    Widget crearItem(PalomarModel palomar) {
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
                    child: Text('${palomar.id}',
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
                    child: Text('${palomar.tipo}',
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
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Ubicación',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('${palomar.ubicacion}',
                        style: TextStyle(color: Colors.blue)),
                    flex: 3,
                  ),
                ],
              ))
        ],
      ));
    }

    Widget _crearcontenido(List<PalomarModel> lista) {
      if (lista.isEmpty) return Container();
      return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) => crearItem(lista[i]));
    }

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: InputCamera(
                    iconData: Icons.camera_alt,
                    onPressed: _traerdatosescanerbandeja,
                    inputParam: InputForm(
                        onPressed: _validarText,
                        controller: _sobreController,
                        fx: f1,
                        hinttext: "Ingresar código",align: TextAlign.center,))),
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
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Clasificar envios"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
