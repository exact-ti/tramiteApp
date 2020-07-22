import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Util/utils.dart';

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;
  ui.Image imagetoDraw;
  _WatermarkPaint(this.price, this.watermark);

  getImageFromAsset() {
    rootBundle.load("assets/logoExact.PNG").then((bd) {
      Uint8List lst = new Uint8List.view(bd.buffer);
      ui.instantiateImageCodec(lst).then((codec) {
        codec.getNextFrame().then((frameInfo) {
          imagetoDraw = frameInfo.image;
          print("bkImage instantiated: $imagetoDraw");
        });
      });
    });
  }

  @override
  Future<void> paint(ui.Canvas canvas, ui.Size size) async {
    double x = 100.0;
    double y = 100.0;
    //canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
    ui.Paint paint = new ui.Paint()
      ..color = new ui.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
    ui.Offset point = new ui.Offset(x, y);
    getImageFromAsset();
    canvas.drawImage(imagetoDraw, point, paint);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _MyHomePageState extends State<MyHomePage2> {
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final botonesinferiores = Row(children: [
      Expanded(
        child:Container(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: ButtonTheme(
          minWidth: 100.0,
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () async {
              final sign = _sign.currentState;
              //retrieve image data, do whatever you want with it (send to server, save locally...)
              final image = await sign.getData();
              var data = await image.toByteData(format: ui.ImageByteFormat.png);
              sign.clear();
              final encoded = base64.encode(data.buffer.asUint8List());
              setState(() {
                _img = data;
              });
              mostrarAlerta(context, "Se registró el cambio", " Guardado");
              debugPrint("onPressed " + encoded);
            },
            color: Color(0xFF2C6983),
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        )),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 1, right: 1),
            child:ButtonTheme(
          minWidth: 100.0,
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              final sign = _sign.currentState;
              sign.clear();
              setState(() {
                _img = ByteData(0);
              });
              debugPrint("cleared");
            },
            color: Color(0xFF858585),
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Limpiar', style: TextStyle(color: Colors.white)),
          ),
        )),
      ),
    ]);

    return Scaffold(
      appBar: sd.crearTitulo('Entrega personalizada'),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top),
                child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.windowClose,
                  color: Color(0xffC7C7C7),
                  size: 25,
                ),
                onPressed: () {
/*                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecepcionInterPage(recorridopage: entrega),
                        )); */
                }),
          ),
          Expanded(
            child: Container(
              child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    debugPrint('${sign.points.length} points in the signature');
                  },
                  strokeWidth: strokeWidth,
                ),
              color: Colors.black12,
            ),
          ),
          Container(
            height:screenHeightExcludingToolbar(context, dividedBy: 8),
            child: botonesinferiores,
          )
        ],
      ),
    ))));
  }
}
