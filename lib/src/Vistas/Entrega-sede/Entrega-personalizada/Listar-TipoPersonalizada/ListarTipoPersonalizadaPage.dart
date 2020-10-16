import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/ModelDto/TipoEntregaPersonalizadaModel.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-DNI/EntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-firma/Generar-Firma/GenerarFirmaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';

import 'ListarTipoPersonalizadaController.dart';
 

class ListarTipoPersonalizadaPage extends StatefulWidget {

  @override
  _ListarTipoPersonalizadaPageState createState() => _ListarTipoPersonalizadaPageState();
  

}

class _ListarTipoPersonalizadaPageState extends State<ListarTipoPersonalizadaPage> {

  ListarTipoPersonalizadaController paqueteExternoController = new ListarTipoPersonalizadaController();

 

  final subtituloStyle = TextStyle(color: sd.colorletra);
  var booleancolor = true;
  var colorwidget = sd.colorplomo;

  @override
  Widget build(BuildContext context) {
    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    var booleancolor = true;
    
    if (booleancolor) {
        colorwidget = colorplomo;
        booleancolor = false;
      } else {
        colorwidget = colorblanco;
        booleancolor = true;
      }

    
    return Scaffold(
      appBar: CustomAppBar(text: "Entrega personalizada"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child:Padding(
        padding: const EdgeInsets.only(left: 20, right: 20,top: 40),
        child: Container(        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child:_crearListaTipoPaquete()    
              )
            ],
          ),
        )
      )
    )));



  }

  Widget _crearListaTipoPaquete() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
          future: paqueteExternoController.listarTiposEntregasPersonalizadas(),
          builder: (BuildContext context, AsyncSnapshot<List<TipoEntregaPersonalizadaModel>> snapshot) {
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
                    final tipoPaquetes = snapshot.data;
                    if (tipoPaquetes.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: tipoPaquetes.length,
                          itemBuilder: (context, i) => _crearItem(tipoPaquetes[i]));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          }
        ),
      ),
    );
  }

  Widget _crearItem(TipoEntregaPersonalizadaModel item){
    if(item.estado==true){
    return Container(
      decoration: myBoxDecoration(),
      margin: EdgeInsets.only(bottom: 5),
      child: InkWell(
              onTap: () {
                _onSearchButtonPressed(item);
              }, // handle your onTap here
              child: Container(child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _informacionItem(item),
            flex: 5,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 80,
                  child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xffC7C7C7), 
                      size: 50
                    )
                )
              ]
            )
          )
        ]
      )
    )));
    }else{
      return Container();
    }

  }
 
  void _onSearchButtonPressed(TipoEntregaPersonalizadaModel item){
    if(item.id==1){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntregapersonalizadoPageDNI(),
      ),
    );
    }else{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerarFirmaPage(),
      ),
    );
    }

  }

  Widget _informacionItem(TipoEntregaPersonalizadaModel item){
      
      String descripcion = item.descripcion;

      return Container(          
          child: ListTile(
                  title: Text("$descripcion"),
                  leading: Icon(
                    Icons.perm_identity,
                    color: Color(0xffC7C7C7),
                  ),
                )
      );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: sd.colorletra),
    );
  }
  

}