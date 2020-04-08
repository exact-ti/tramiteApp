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

  final paquetesExternos = ['Chequeras','Verbales','Campañas'];
  final  primaryColor = Color(0xFF2C6983);

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

    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Custodia de documentos externos',
              style: TextStyle(
                        fontSize: 18,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal))
      ),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Container(
        //padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
              child: Align(                
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child: Text('Elige el tipo de paquete',

                      style: TextStyle(
                        fontSize: 18,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal)

                    )),
              ),
              
              
            ),

            
            SafeArea(
              //padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
               
              child: Align(

                child: Column(
                  children : <Widget>[_listadoTipoPaqueteExterno()]
                )                
              ),
            )
              //alignment: Alignment.center,
              // decoration: new BoxDecoration(
              // color: colorwidget,
              // border: new Border(top: BorderSide(color: colorplomo)))


            
          ],

        ),

      )
                      
    
    );



  }

  Widget _listadoTipoPaqueteExterno(){

    return FutureBuilder(
      future: paqueteExternoController.listarPaquetesPorTipo(false),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<TipoPaqueteModel>> snapshot) {

        var widgets;

        if (snapshot.hasData){

          widgets = snapshot.data.map((item){
            return Column (
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImportarArchivoPage(tipoPaqueteModel: item),
                      ),
                    );
                  },
                  title: Text(item.nombre),
                  trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xffC7C7C7),
                  )
                ),
                Divider(color: primaryColor,)
              ]
            );
          }).toList();

        } else if (snapshot.hasError){
          widgets = <Widget>[Column()].toList();
        }
        else {
          widgets = <Widget>[Column()].toList();
        }
        return Column(
          children: widgets,
          );

      },
    );
  }

  

}