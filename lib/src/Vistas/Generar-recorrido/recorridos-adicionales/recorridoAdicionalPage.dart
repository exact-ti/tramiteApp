import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-adicionales/recorridoAdicionalController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/InputForm.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class RecorridosAdicionalesPage extends StatefulWidget {
  @override
  _RecorridosAdicionalesPageState createState() =>
      _RecorridosAdicionalesPageState();
}

class _RecorridosAdicionalesPageState extends State<RecorridosAdicionalesPage> {
  RecorridoAdicionalController principalcontroller = new RecorridoAdicionalController();
  String textdestinatario = "";
  final _destinatarioController = TextEditingController();
  FocusNode f1Destinatario = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget informacionEntrega(RecorridoModel envio) {
      String horario = envio.horaInicio + " - " + envio.horaFin;
      return Container(
          height: 100,
          child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 20,
                  child: ListTile(title: Text("${envio.nombre}")),
                ),
                Container(
                    height: 20,
                    child: ListTile(
                        title:
                            Text("$horario", style: TextStyle(fontSize: 11)))),
                Container(
                    height: 20,
                    child: ListTile(
                      title: Text("${envio.usuario}"),
                      leading: Icon(
                        Icons.perm_identity,
                        color: Color(0xffC7C7C7),
                      ),
                    )),
              ]));
    }

    Widget crearItem(RecorridoModel recorridoModel) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ValidacionEnvioPage(recorridopage: recorridoModel),
                  ),
                );
              },
              child: Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: informacionEntrega(recorridoModel),
                        flex: 5,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 100,
                                    child: Icon(Icons.keyboard_arrow_right,
                                        color: StylesThemeData.LETTERCOLOR,
                                        size: 50))
                              ])),
                    ]),
              )));
    }

    Widget _crearListadoporfiltro(String texto) {
      return FutureBuilder(
          future: principalcontroller.recorridosController(texto),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
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
                    final entregas = snapshot.data;
                    if (entregas.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: entregas.length,
                          itemBuilder: (context, i) => crearItem(entregas[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    Widget _myListView(String buscador) {
      if (buscador == "") {
        return Container();
      } else {
        return _crearListadoporfiltro(buscador);
      }
    }

    void onChanged() {
      setState(() {
        textdestinatario = _destinatarioController.text;
      });
    }

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  width: double.infinity,
                  child: InputForm(
                      onPressed: null,
                      onChanged: onChanged,
                      controller: _destinatarioController,
                      fx: f1Destinatario,
                      hinttext: 'Ingresar nombre')),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: _myListView(textdestinatario)),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Nueva entrega en sede"),
        drawer: DrawerPage(),
        body: scaffoldbody(mainscaffold(), context));
  }
}
