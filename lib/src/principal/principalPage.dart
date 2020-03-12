import 'package:flutter/material.dart';
import 'package:tramiteapp/src/principal/principalController.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {

    const colorplomo = const Color(0xFFEAEFF2);
    const colorblanco = const Color(0xFFFFFFFF);
    const colorborde = const Color(0xFFD5DCDF);


    PrincipalController principalcontroller = new PrincipalController();

TextEditingController _rutController = TextEditingController();

    var listadestinatarios;


    Widget _myListView(String buscador) {

      List<Widget> list = new List<Widget>();
  /*
      if(listadestinatarios==null){
          list.add(new  Container(
            child: new ListTile(
            title: new Text(""),
            )));

       return new ListView(children: list
      );
      }*/

      var listadestinataris = principalcontroller.ListarDestinario();
      var booleancolor = true;
      var colorwidget = colorblanco; 
      for (Map<String, dynamic> destinatario in listadestinataris) {
        
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
            title: new Text(destinatario["nombre"]),
            subtitle:new Text(destinatario["area"]) ,
            trailing:Icon(Icons.keyboard_arrow_right)
            ),     
            //height: 70,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
            color: colorwidget,
            border: new Border(top: BorderSide(color:colorborde))
            )));
        print(destinatario["nombre"]);
      }

      return new ListView(children: list
      );
    }
    
    
    String _text = "";


    void onChangedApplyFormat(String text) {
      /*var lista = principalcontroller.ListarDestinario(text);
      for (Map<String, dynamic> list in lista) {
        print(text.length);
      }*/
      listadestinatarios = principalcontroller.ListarDestinario();

      setState(() => 
      _text = text
      ); // you need this
            
    }


    final destinatario = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      //controller: _rutController,
      //textAlign: TextAlign.center,
      /*onChanged: (text) {
              setState(() => _text = text); // you need this
            },*/
      decoration: InputDecoration(
        border: InputBorder.none,
        //focusedBorder: InputBorder.none,
        prefixIcon:Icon(Icons.search),
        //border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xffF0F3F4),
        hintText: 'Ingrese destinatario',
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final titulo = Row(children: <Widget>[
      Text('Generar envío',   style: TextStyle(
            fontSize: 10
          )),
      SizedBox(width: 250, child: TextField()),
    ]);

    const PrimaryColor = const Color(0xFF35B6EB);
return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Generar envío',   style: TextStyle(
            fontSize: 18
          )),
      ),
      body: 
      Padding(
      padding: const EdgeInsets.only(left:20,right: 20 ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.center,
              height: screenHeightExcludingToolbar(context, dividedBy: 8),
              width: double.infinity,
              child: destinatario
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child:  _myListView("")
            ),
          )
        ],
      ),
)
      
      
    );

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
