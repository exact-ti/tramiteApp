import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoController.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoPage.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
 

class PaqueteExternoPage extends StatefulWidget {

  @override
  _PaqueteExternoPageState createState() => _PaqueteExternoPageState();
  

}

class _PaqueteExternoPageState extends State<PaqueteExternoPage> {

  PaqueteExternoController paqueteExternoController = new PaqueteExternoController();

 

  final subtituloStyle = TextStyle(color: sd.colorletra);
  var booleancolor = true;
  var colorwidget = sd.colorplomo;

  @override
  Widget build(BuildContext context) {

    
    const LetraColor = const Color(0xFF68A1C8);
    const Colorplomo = const Color(0xFFEAEFF2);

    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);
    var booleancolor = true;
    var colorwidget = colorplomo;
    
    if (booleancolor) {
        colorwidget = colorplomo;
        booleancolor = false;
      } else {
        colorwidget = colorblanco;
        booleancolor = true;
      }

    
    return Scaffold(
      appBar: sd.crearTitulo('Custodia de documentos externos'),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child:Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _subtitulo(),
              _crearListaTipoPaquete()              
            ],
          ),
        )
      )
    )));



  }

  

  Widget _subtitulo(){
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
              child: Text('Elige el tipo de paquete',
              style: subtituloStyle
              ),
              flex: 5,
            )
          ],
        ),
      )
    );
  }

  Widget _crearListaTipoPaquete() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
          future: paqueteExternoController.listarPaquetesPorTipo(false),
          builder: (BuildContext context, AsyncSnapshot<List<TipoPaqueteModel>> snapshot) {
            if (snapshot.hasData) {
              final tipoPaquetes = snapshot.data;
              return ListView.builder(
                itemCount: tipoPaquetes.length,
                itemBuilder: (context,i) => _crearItem(tipoPaquetes[i]),
              );
            }
            else{
              return Container();
            }
          }
        ),
      ),
    );
  }

  Widget _crearItem(TipoPaqueteModel item){
    if (booleancolor) {
      colorwidget = sd.colorplomo;
      booleancolor = false;
    } else {
      colorwidget = sd.colorblanco;
      booleancolor = true;
    }
    return Container(
      decoration: myBoxDecoration(),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _informacionItem(item),
            flex: 5,
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xffC7C7C7), 
                      size: 50
                    ),
                    onPressed: (){
                      _onSearchButtonPressed(item);
                    }
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
 
  void _onSearchButtonPressed(TipoPaqueteModel item){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImportarArchivoPage(tipoPaqueteModel: item),
      ),
    );
  }

  Widget _informacionItem(TipoPaqueteModel item){
      
      String descripcion = item.nombre;

      return Container(          
          child: ListView(
            shrinkWrap: true, 
            children: <Widget>[
                                
              Container(                
                child: ListTile(
                  title: Text("$descripcion"),
                  leading: Icon(
                    Icons.description,
                    color: Color(0xffC7C7C7),
                  ),
                )
              ),
               
              
            ]
          )
      );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: sd.colorletra),
    );
  }
  

}