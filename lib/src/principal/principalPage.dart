import 'package:flutter/material.dart';
import 'package:tramiteapp/src/principal/principalController.dart';


TextEditingController _rutController = TextEditingController();

class PrincipalPage extends StatefulWidget {

  @override
  _PrincipalPageState createState() => _PrincipalPageState();

}

class _PrincipalPageState extends State<PrincipalPage> {
  


  

      @override
      Widget build(BuildContext context) {

        Widget _myListView() {
      return ListView(
        children:<Widget>[
        Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
                Container(
        child: new ListTile(
          title: new Text('Victor Chumacahua'),
          trailing: new Text('Operativo Vida')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Javier Soto'),
          trailing: new Text('Comercial')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Luna Lopez'),
          trailing: new Text('Gerencia')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Christian campos'),
          trailing: new Text('Tecnologia de información')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Orlando Heredia'),
          trailing: new Text('Tramite Documental')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Ronald Santos'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Kathy Vega'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
        Container(
        child: new ListTile(
          title: new Text('Yohan Mamani'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Kathetleen Macedo'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('GianMarco Vargas'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
         Container(
        child: new ListTile(
          title: new Text('Sebastian Vilela'),
          trailing: new Text('BCP')
        ),
        decoration:
            new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide()
                )
            )
        ),
  

            ]
      );
    }
     PrincipalController principalcontroller = new PrincipalController();

     void onChangedApplyFormat(String text) {
            var lista = principalcontroller.ListarDestinario();
            for(Map<String, dynamic> list in lista){
                 print(list["nombre"]); 
            }
        print("dads"); 
    }

  final destinatario = TextFormField(
    keyboardType: TextInputType.text,
    autofocus: false,
    controller: _rutController,
    //textAlign: TextAlign.center,
    onChanged: onChangedApplyFormat,
        decoration: InputDecoration(
          //border: InputBorder.none,
          //focusedBorder: InputBorder.none,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xffF0F3F4),
          hintText: 'Ingrese destinatario',
          contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 20.0),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      );
    
      final titulo = Row(children: <Widget>[
        Text('Generar envío'),
        SizedBox(width: 250, child: TextField()),
      ]);
      


        const PrimaryColor = const Color(0xFF35B6EB);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text('Generar envío'),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 5.0,),
              destinatario,
              SizedBox(height: 48.0),
              Container(
              /*decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,// set border color
                width: 1.0), 
              ),*/
              child: SizedBox(height: 639.0,
              child:_myListView()
              )
              )    

              ],
          ),
        );
      }
  

}
