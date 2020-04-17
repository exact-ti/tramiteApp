import 'dart:collection';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
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


    Widget  crearItem(UsuarioFrecuente usuario) {
          if (booleancolor) {
                colorwidget = colorplomo;
                booleancolor = false;
              } else {
                colorwidget = colorblanco;
                booleancolor = true;
              }
      return  Container(
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
          //height: 70,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: colorwidget,
              border: new Border(top: BorderSide(color: colorborde))));
    }

    Widget crearItemVacio() {
      return Container();
    }

    Widget _crearListado() {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.listarusuariosfrecuentes(),
          builder: (BuildContext context,
              AsyncSnapshot<List<UsuarioFrecuente>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              colorwidget = colorplomo;
              final usuarios = snapshot.data;
              return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, i) => crearItem(usuarios[i]));
            } else {
              return Container();
            }
          });
    }

    Widget _crearListadoporfiltro(String texto) {
      booleancolor = true;
      colorwidget = colorplomo;
      return FutureBuilder(
          future: principalcontroller.listarUsuariosporFiltro(texto),
          builder: (BuildContext context,
              AsyncSnapshot<List<UsuarioFrecuente>> snapshot) {
            if (snapshot.hasData) {
              booleancolor = true;
              final usuarios = snapshot.data;
              return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, i) => crearItem(usuarios[i]));
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
        //listadestinataris = principalcontroller.listarusuariosfrecuentes();
        return _crearListado();

        /*setState(() {
            if(nuevo==2){
              prueba=null;
            }else{
            prueba=Text("Usuarios frecuentes",style: TextStyle(
            fontSize: 15,color: Color(0xFFACADAD)));
            }
            nuevo++;
          });*/
      } else {
        //listadestinataris = principalcontroller.ListarDestinario(buscador);
        return _crearListadoporfiltro(buscador);
        /*setState(() {
              prueba=null;
          });*/
      }

/*
      if(listadestinataris==null /*|| buscador.length<2*/){
          list.add(new  Container(
            child: new ListTile(
            title: new Text(""),
            )));

       return new ListView(children: list
      );
      }

      var booleancolor = true;
      var colorwidget = colorblanco; 
      for (Map<String,dynamic> destinatario in listadestinataris) {
        
        if(booleancolor){
            colorwidget = colorplomo;
            booleancolor=false;
        }else{
          colorwidget= colorblanco;
            booleancolor=true;
        }  

        list.add(new  Container(
            child: new ListTile(
            onTap: () {},     
            title: new Text(destinatario.nombre,style: TextStyle(
            fontSize: 15)),
            subtitle:new Text(destinatario.sede + " - "+ destinatario.area,style: TextStyle(
            fontSize: 12)) ,
            trailing:Icon(Icons.keyboard_arrow_right,color:Color(0xffC7C7C7) ,)
            ),     
            //height: 70,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
            color: colorwidget,
            border: new Border(top: BorderSide(color:colorborde))
            )));
      }
      return new ListView(children: list
      );*/
    }

    String _text = "";

    /*
    void onChangedApplyFormat(String text) {
      /*var lista = principalcontroller.ListarDestinario(text);
      for (Map<String, dynamic> list in lista) {
        print(text.length);
      }*/
      listadestinatarios = principalcontroller.ListarDestinario(text);

      setState(() => 
      _text = text
      ); // you need this
            
    }*/

    final destinatario = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onChanged: (text) {
        setState(() {
          textdestinatario = text;
          /*listadetinatarioDisplay = listadetinatario.where((destinatario){
                    var nombredestinatario = destinatario["nombre"];
                    return nombredestinatario.contains(text);
                  }).toList();*/
          //var nombre = "asdads";
        });
      },
      //controller: _rutController,
      //textAlign: TextAlign.center,
      /*  : (text) {
              setState(() => _text = text); // you need this
            },*/
      decoration: InputDecoration(
        //border: InputBorder.none,
        //focusedBorder: InputBorder.none,
        prefixIcon: Icon(Icons.search),
        contentPadding: new EdgeInsets.symmetric(vertical: 11.0),
        //border: OutlineInputBorder(),
        filled: true,
        //fillColor: Color(0xffF0F3F4),
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
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color: Color(0xffF0F3F4),width: 0.0)),
      ),
    );

    final titulo = Row(children: <Widget>[
      Text('Generar envío', style: TextStyle(fontSize: 10)),
      SizedBox(width: 250, child: TextField()),
    ]);

    /*final prueba = Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.bottomLeft,
              height: screenHeightExcludingToolbar(context, dividedBy: 40),
              width: double.infinity,
              child: Text("Usuarios Frecuentes:",style: TextStyle(
            fontSize: 15,color: Color(0xFFACADAD)))
            )
            ,
          );*/

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
        drawer: sd.crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    alignment: Alignment.center,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child: destinatario),
              ),
              Row(
                children: <Widget>[
                  textdestinatario != "" ? Container() : prueba
                ],
              ),
              /* Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: screenHeightExcludingToolbar(context, dividedBy: 40),
                    width: double.infinity,
                    child: Text("Usuarios Frecuentes:",style: TextStyle(
                  fontSize: 15,color: colorletra))
                  )
                  ,
                ),*/
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: _myListView(textdestinatario)),
              )
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

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
}
