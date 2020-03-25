

/*import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name = '';
  String _label = 'im a label';

  void _setName() {
    setState(() {
      _name = 'Bobby';
    });
  }


  void _setLabel() {
    setState(() {
      _label = 'First Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: TextEditingController(
                text: _name,
              ),
              decoration: InputDecoration(
                labelText: _label,
              ),
            ),
            RaisedButton(
              onPressed: _setName,
              child: const Text('Set text to "Bobby"'),
            ),
            RaisedButton(
              onPressed: _setLabel,
              child: const Text('Set label to "First Name"'),
            ),
          ],
        ),
      ),
    );
  }
}
*/