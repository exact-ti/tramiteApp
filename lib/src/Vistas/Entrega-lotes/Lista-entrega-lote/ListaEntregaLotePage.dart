


import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Entrega-lotes/Lista-entrega-lote/ListaEntregaLoteController.dart';

class ListaEntregaLotePage extends StatefulWidget{
  @override
  _ListaEntregaLotePageState createState() => new _ListaEntregaLotePageState();
}

class _ListaEntregaLotePageState extends State<ListaEntregaLotePage> {

  ListaEntregaLoteController listarLoteController = new ListaEntregaLoteController();

  final titulo = 'Entregas de Lotes';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: sd.crearTitulo(titulo),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Container(
         padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,          
          
          children: <Widget>[
            _generarBotonNuevo(context),
            Container(child:_generarControlTab2(context),)
          ]
        )
      ),

    );
  }


  Widget _generarControlTab(BuildContext context){

    return Expanded(
      child: MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              
              bottom: TabBar(
                tabs: [
                  
                  Tab(text: 'Enviados'),
                  Tab(text: 'Por recibir'),
                  
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(child:Text('hola')),
                Container(child:Text('hola')),
              ]
            ),
          )
        )
      )
    );
  }


  Widget _generarBotonNuevo(BuildContext context){

    return Container(
      padding: const EdgeInsets.only(
            left: 20, right: 20, top: 10, bottom: 0),
      child: Align(                
        child: Container(
            alignment: Alignment.centerLeft,
            height: sd.screenHeightExcludingToolbar(context, dividedBy: 10),
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),                      
              textColor: Colors.white,                      
              color: sd.primaryColor,
              
              child: Text('Nuevo', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {
                //contenido = _adjuntarArchivo(context);
              }              
            )),
      ),
    );
  }




Widget _generarControlTab2(BuildContext context){

    return Expanded(
    
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                
                bottom: TabBar(
                  tabs: [
                    
                    Tab(text: 'Enviados'),
                    Tab(text: 'Por recibir'),
                    
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Container(child:Text('hola')),
                  Container(child:Text('hola')),
                ]
              ),
            )
          
        )
      )
    );
  }










}