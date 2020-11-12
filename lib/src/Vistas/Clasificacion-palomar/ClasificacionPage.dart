import 'package:tramiteapp/src/ModelDto/PalomarModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/InputWidget.dart';
import 'ClasificacionController.dart';

class ClasificacionPage extends StatefulWidget {
  @override
  _ClasificacionPageState createState() => _ClasificacionPageState();
}

class _ClasificacionPageState extends State<ClasificacionPage> {
  ClasificacionController principalcontroller = new ClasificacionController();
  final _sobreController = TextEditingController();
  PalomarModel palomarModel = new PalomarModel();
  List<PalomarModel> listapalomar = [];
  FocusNode f1 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _validarText(dynamic valueSobreController) async {
    desenfocarInputfx(context);
    dynamic palomarData = await principalcontroller.listarpalomarByCodigo(
        context, valueSobreController);
    if (palomarData["status"] == "success") {
      dynamic datapalomar = palomarData["data"];
      PalomarModel palomar = this.palomarModel.fromOneJson(datapalomar);
      listapalomar.clear();
      setState(() {
        _sobreController.text = valueSobreController;
        listapalomar.add(palomar);
      });
    } else {
      popuptoinput(context, f1, "error", "EXACT", palomarData["message"]);
      setState(() {
        _sobreController.text = valueSobreController;
        listapalomar.clear();
      });
    }
  }

  Future _traerdatosescanerbandeja() async {
    _sobreController.text = await getDataFromCamera(context);
    setState(() {
      _sobreController.text = _sobreController.text;
    });
    _validarText(_sobreController.text);
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
                margin: const EdgeInsets.only(top: 20),
                child: InputWidget(
                  iconSufix: IconsData.ICON_CAMERA,
                  iconPrefix: IconsData.ICON_SOBRE,
                  methodOnPressedSufix: _traerdatosescanerbandeja,
                  methodOnPressed: _validarText,
                  controller: _sobreController,
                  focusInput: f1,
                  hinttext: "Ingresar código",
                  align: TextAlign.center,
                )),
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
