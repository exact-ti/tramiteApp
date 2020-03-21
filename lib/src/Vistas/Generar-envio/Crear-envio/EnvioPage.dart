import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'EnvioController.dart';

class EnvioPage extends StatefulWidget {
  final UsuarioFrecuente usuariopage;

  const EnvioPage({Key key, this.usuariopage}) : super(key: key);

  @override
  _EnvioPageState createState() => new _EnvioPageState(usuariopage);
}

class _EnvioPageState extends State<EnvioPage> {
  UsuarioFrecuente recordObject;
  _EnvioPageState(this.recordObject);
  EnvioController envioController;

  Widget datosUsuarios(String text) {
    return ListTile(title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  Widget datosUsuariosArea(String text) {
    return ListTile(
        leading: Icon(Icons.location_on),
        title: new Text(text, style: TextStyle(fontSize: 15)));
  }

  final observacion = Card(
      color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          maxLines: 8,
          decoration:
              InputDecoration.collapsed(hintText: "Enter your text here"),
        ),
      ));

  final loginButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 70),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        //performLogin(context);
        //Navigator.of(context).pushNamed("principal");
      },
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      color: Colors.lightBlueAccent,
      child: Text('LOG IN', style: TextStyle(color: Colors.white)),
    ),
  );

  final codigo = TextFormField(
    keyboardType: TextInputType.text,
    autofocus: false,
    style: new TextStyle(height: 0.2),
    decoration: InputDecoration(
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
          color: Color(0xff4693C7),
          width: 0.0,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8);
    const Colorplomo = const Color(0xFFEAEFF2);

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.keyboard_arrow_left,
                color: Colors.white, size: 25),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: PrimaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
          title: Text('Generar envío',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 35,
                    child:                   ListTile(
                    leading: Icon(Icons.perm_identity), //account_circle
                    title: Align(
                      child: new Text(recordObject.nombre,
                          style: TextStyle(fontSize: 15)),
                      alignment: Alignment(-1.2, 0),
                    ),
                  ),
                  )
,//recordObject.area + " - " + recordObject.sede
                 ListTile(
                    leading: Icon(Icons.location_on), //account_circle
                    title: Align(
                      child: new Text(recordObject.area + " - " + recordObject.sede,
                          style: TextStyle(fontSize: 15)),
                      alignment: Alignment(-1.2, 0),
                    ),
                  ),
                  Container(  
                    margin: const EdgeInsets.only(top: 15, bottom: 0),
                    height: 40,
                    child: ListTile(
                        title: new Text("Código de sobre",
                            style: TextStyle(fontSize: 15))),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: codigo,
                      flex: 10,
                    ),
                    Expanded(
                      child: Icon(Icons.camera_alt),
                      flex: 1
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 0),
                    child: ListTile(
                        title: new Text("Código de sobre",
                            style: TextStyle(fontSize: 15))),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: codigo,
                      flex: 10,
                    ),
                    Expanded(
                      child: Icon(Icons.camera_alt),
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 0),
                    child: ListTile(
                        title: new Text("Observación",
                            style: TextStyle(fontSize: 15))),
                  ),
                  observacion,
                  loginButton
                ])));
  }
}
//                  Navigator.of(context).pushNamed(men.link);
