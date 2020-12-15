import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:tramiteapp/src/Vistas/Login/loginPage.dart';
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
      child:MaterialApp(
        title: 'Componentes App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: getAplicationRoutes(null),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('es')],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => LoginPage());
        },
        navigatorKey: locator<NavigationService>().navigatorKey));
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  String _statusText = "Waiting...";
  final String _finished = "Finished creating channel";
  final String _error = "Error while creating channel";

  static const MethodChannel _channel =
      MethodChannel('somethinguniqueforyou.com/channel_test');

  Map<String, String> channelMap = {
    "id": "CHAT_MESSAGES",
    "name": "Chats",
    "description": "Chat notifications",
  };

  void _createNewChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      setState(() {
        _statusText = _finished;
      });
    } on PlatformException catch (e) {
      _statusText = _error;
      print(e);
    }
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
            Text(
              _statusText,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChannel,
        child: Icon(Icons.add),
      ),
    );
  }
} */