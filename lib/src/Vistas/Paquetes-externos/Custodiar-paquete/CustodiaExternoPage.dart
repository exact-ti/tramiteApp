import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Custodiar-paquete/CustodiaExternoController.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Elegir-paquete/PaqueteExternoController.dart';

class CustodiaExternoPage extends StatefulWidget {

  @override
  _CustodiaExternoPageState createState() => new _CustodiaExternoPageState();

}


class _CustodiaExternoPageState extends State<CustodiaExternoPage>{

  CustodiaController custodiaController = new CustodiaController();
  
  @override
  Widget build(BuildContext context) {

    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8); 

    Size screenSize(BuildContext context) {
      return MediaQuery.of(context).size;
    }

    double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
      return (screenSize(context).height - reducedBy) / dividedBy;
    }

    double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
      return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
    }
    // _listarPaquetesCreados();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Custodia de documentos externos',
          style: TextStyle(
            fontSize: 18,
            decorationStyle: TextDecorationStyle.wavy,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal)
        )
    ),
    drawer: sd.crearMenu(context),
    backgroundColor: Colors.white,

    body: Padding(

      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                alignment: Alignment.center,
                height: screenHeightExcludingToolbar(context, dividedBy: 6),
                width: double.infinity,
                child: Container(
                  child: Column( 
                    children: <Widget>[
                      Text('Código documento'),
                      TextField(
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // hintText: 'Ingrese el código del paquete'
                        ),
                      )
                    ]
                  )
                )
            ),
          ),
          Expanded(
            child: Container(
                  alignment: Alignment.bottomCenter, 
                  child: _crearListado()),
          )
        ]
      ),
      
    ),




    );
  }

  var contenido;

  List<PaqueteExterno> p = new List<PaqueteExterno>();

  // void _listarPaquetesCreados() async {
  //   this.p = await _listarCreados();
  //   contenido =  _crearLista();       
  // }

  Widget _crearListado() {
    return FutureBuilder(
      future: _listarCreados(),
      builder: (BuildContext context, AsyncSnapshot<List<PaqueteExterno>> snapshot) {
        if (snapshot.hasData) {              
              final creados = snapshot.data;
              return ListView.builder(
                  itemCount: creados.length,
                  itemBuilder: (context, i) => crearItem(creados[i]));
            } else {
              return Container();
            }
      }
    );
  }

  var colorletra = const Color(0xFFACADAD);

  Widget crearItem(PaqueteExterno paquete) {
    
    return Container(
      decoration: myBoxDecoration(),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: 
                informacionPaquete(paquete),
              flex: 5,
            ),
           
          ]),
    );
  }

  Widget informacionPaquete (PaqueteExterno p){
    return Container(
      
      height: 50,
      child: ListView(shrinkWrap: true, 
        children: <Widget>[
          Container(
              height: 20,
              child: ListTile(title: Text(p.paqueteId)),
            ),
          
        ]
      )
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
  }

  Future<List<PaqueteExterno>> _listarCreados() async {
    List<PaqueteExterno> paqueteList = await custodiaController.listarPaquetesExternosCreados();
    return paqueteList;
  }

  // Widget _crearLista(){

  //   return ListView.builder(
  //     itemCount: this.p.length,
  //     itemBuilder: (BuildContext context, int index){
        
  //       PaqueteExterno paquete = this.p[index];

  //       _generateItemList(paquete);

  //     }
  //   );
  // }

  Widget _generateItemList(PaqueteExterno paq) {

    return ListTile(      
      title: Text(paq.paqueteId),
      trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Color(0xffC7C7C7),
      )
    );
  }


}