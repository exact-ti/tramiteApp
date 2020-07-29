import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/recorridos-adicionales/recorridoAdicionalController.dart';
import 'package:tramiteapp/src/Vistas/Generar-recorrido/validar-envios/validarEnvioPage.dart';

class RecorridosAdicionalesPage extends StatefulWidget {
  @override
  _RecorridosAdicionalesPageState createState() =>
      _RecorridosAdicionalesPageState();
}

class _RecorridosAdicionalesPageState extends State<RecorridosAdicionalesPage> {
  RecorridoAdicionalController principalcontroller =
      new RecorridoAdicionalController();
  EnvioController envioController = new EnvioController();
  //TextEditingController _rutController = TextEditingController();

  var listadestinatarios;
  String textdestinatario = "";

  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;

  var nuevo = 0;

  @override
  void initState() {
    //listadetinatario= principalcontroller.ListarDestinario();
    prueba = Text("Usuarios frecuentes",
        style: TextStyle(fontSize: 15, color: Color(0xFFACADAD)));

    setState(() {
      //listadetinatario =principalcontroller.ListarDestinario();
      //listadetinatarioDisplay = listadetinatario;

      /* */

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

    Widget informacionEntrega(RecorridoModel envio) {
      String recorrido = envio.nombre;
      String horario = envio.horaInicio + " - " + envio.horaFin;
      String usuario = envio.usuario;

      return Container(
          height: 100,
          child: ListView(shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: 20,
              child: ListTile(title: Text("$recorrido")),
            ),
            Container(
                height: 20,
                child: ListTile(
                    title: Text("$horario", style: TextStyle(fontSize: 11)))),
            Container(
                height: 20,
                child: ListTile(
                  title: Text("$usuario"),
                  leading: Icon(
                    Icons.perm_identity,
                    color: Color(0xffC7C7C7),
                  ),
                )),
          ]));
    }

    Widget crearItem(RecorridoModel recorridoModel) {
      return Container(
          decoration: myBoxDecoration(),
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
              }, // handle your onTap here
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
                                        color: Color(0xffC7C7C7), size: 50))
                              ])),
                    ]),
              )));
    }

    Widget crearItemVacio() {
      return Container();
    }

    Widget _crearListadoporfiltro(String texto) {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.recorridosController(texto),
          builder: (BuildContext context,
              AsyncSnapshot<List<RecorridoModel>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              final recorridos = snapshot.data;
              return ListView.builder(
                  itemCount: recorridos.length,
                  itemBuilder: (context, i) => crearItem(recorridos[i]));
            } else {
              return ListView.builder(
                  itemCount: 1, itemBuilder: (context, i) => crearItemVacio());
            }
          });
    }

    Widget _myListView(String buscador) {
      List<Widget> list = new List<Widget>();
      List<Map<String, dynamic>> listadestinataris;
      if (buscador == "") {
        return Container();
      } else {
        return _crearListadoporfiltro(buscador);
      }
    }

    final destinatario = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onChanged: (text) {
        setState(() {
          textdestinatario = text;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        contentPadding: new EdgeInsets.symmetric(vertical: 11.0),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color(0xffF0F3F4),
            width: 0.0,
          ),
        ),
        hintText: 'Ingrese nombre',
      ),
    );

    final titulo = Row(children: <Widget>[
      Text('Generar envío', style: TextStyle(fontSize: 10)),
      SizedBox(width: 250, child: TextField()),
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
          title: Text('Nueva entrega en sede',
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            alignment: Alignment.center,
                            height: screenHeightExcludingToolbar(context,
                                dividedBy: 10),
                            width: double.infinity,
                            child: destinatario),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: _myListView(textdestinatario)),
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

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }
}
