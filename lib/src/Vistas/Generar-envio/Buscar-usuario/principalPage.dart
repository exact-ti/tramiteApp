import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Buscar-usuario/principalController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioPage.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  PrincipalController principalcontroller = new PrincipalController();
  EnvioController envioController = new EnvioController();
    int cantidad = obtenerCantidadMinima();
  var listadestinatarios;
  String textdestinatario = "";

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

    Widget crearItem(UsuarioFrecuente usuario) {
      if (booleancolor) {
        colorwidget = colorplomo;
        booleancolor = false;
      } else {
        colorwidget = colorblanco;
        booleancolor = true;
      }
      return Container(
          child: new ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnvioPage(usuariopage: usuario),
                  ),
                );
              },
              title: new Text(usuario.nombre, style: TextStyle(fontSize: 15)),
              subtitle: new Text(usuario.sede + " - " + usuario.area,
                  style: TextStyle(fontSize: 12)),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xffC7C7C7),
              )),
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: colorwidget,
              border: new Border(top: BorderSide(color: colorborde))));
    }
      
      dynamic retonarFuncion(String texto){
              final futureVar = principalcontroller.listarUsuariosporFiltro(texto);
    return futureVar;
      } //calling the function here instead and storing its future in a variable

    Widget _crearListadoporfiltro(String texto) {
      booleancolor = true;
      colorwidget = colorplomo;
      List<UsuarioFrecuente> usuarios = [];
      if(this.cantidad>texto.length&&texto.length>0){
        return Container();
      }else{
              return FutureBuilder(
          future: retonarFuncion(texto),
          builder: (BuildContext context,
              AsyncSnapshot<List<UsuarioFrecuente>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                    child: new Text('No hay conexión con el servidor'));
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return Center(child: new Text('Ha surgido un problema'));
                } else {
                  if (snapshot.hasData) {
                    booleancolor = true;
                    usuarios = snapshot.data;
                    if (usuarios.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: usuarios.length,
                          itemBuilder: (context, i) => crearItem(usuarios[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });

      }
    }

    Widget _myListView(String buscador) {
      return _crearListadoporfiltro(buscador);
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
        hintText: 'Ingrese destinatario',
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
          title: Text('Generar envío',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        resizeToAvoidBottomInset: false, 
        resizeToAvoidBottomPadding: false,
        // set it to false
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
                      Row(
                        children: <Widget>[
                          textdestinatario != "" ? Container() : prueba
                        ],
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
}
