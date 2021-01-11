/* import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:isolate';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Isolates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;
 
  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
        print("done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _counter++;
      String msg = 'notification ' + _counter.toString();      
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) {
    print('RECEIVED: ' + data);
    setState(() {      
      notification = data;
    });
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
          _running = false; 
          notification = '';   
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              notification,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _running ? _stop : _start,
        tooltip: _running ? 'Timer stop' : 'Timer start',
        child: _running ? new Icon(Icons.stop) : new Icon(Icons.play_arrow),
      ),
      );
  }
} */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
import 'package:tramiteapp/src/app_retain_widget.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/routes/routes.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/Util/timezone.dart' as timezone;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';



void main() async {
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await prefs.initPrefs();
  tz.initializeTimeZones();
  print(timezone.parse('2020-06-10 13:56'));
  setupLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(MyApp()),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => new NotificationInfo(),
        child: MaterialApp(
            title: 'Componentes App', 
            debugShowCheckedModeBanner: false,
            home:   AppRetainWidget ( child:  LoginPage(), ), 
            routes: getAplicationRoutes(null),
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [const Locale('en'), const Locale('es')],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                  builder: (BuildContext context) =>LoginPage());
            },
            navigatorKey: locator<NavigationService>().navigatorKey));
  }
}
