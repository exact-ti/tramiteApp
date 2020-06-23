import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/prueba/ImagenLoader.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;
    ui.Image imagetoDraw;
  _WatermarkPaint(this.price, this.watermark);

     getImageFromAsset(){
    rootBundle.load("assets/logoExact.PNG").then( (bd) {
      Uint8List lst = new Uint8List.view(bd.buffer);
      ui.instantiateImageCodec(lst).then( (codec) {
        codec.getNextFrame().then(
                (frameInfo) {
              imagetoDraw = frameInfo.image;
              print ("bkImage instantiated: $imagetoDraw");
            }
      );
    });
  });
  }

  @override
  Future<void> paint(ui.Canvas canvas, ui.Size size) async {
      double x = 100.0;
      double y = 100.0;
    //canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
      ui.Paint paint = new ui.Paint()..color = new ui.Color.fromARGB(0xff, 0xff, 0xff, 0xff);
      ui.Offset point = new ui.Offset(x, y);
      getImageFromAsset();
      canvas.drawImage( imagetoDraw, point, paint);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _WatermarkPaint && runtimeType == other.runtimeType && price == other.price && watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _MyHomePageState extends State<MyHomePage> {
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
            const PrimaryColor = const Color(0xFF2C6983);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text('Bienvenido',
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal)),
          ),
                    drawer: sd.crearMenu(context),
          backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color, 
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    debugPrint('${sign.points.length} points in the signature');
                  },
                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
              color: Colors.black12,
            ),
          ),
          _img.buffer.lengthInBytes == 0 ? Container() : LimitedBox(maxHeight: 200.0, child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      color: Colors.green,
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
                        mostrarAlerta(context,"Se registró el cambio"," Guardado");
                        debugPrint("onPressed " + encoded);
                      },
                      child: Text("Guardar")),
                  MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        final sign = _sign.currentState;
                        sign.clear();
                        setState(() {
                          _img = ByteData(0);
                        });
                        debugPrint("cleared");
                      },
                      child: Text("Limpiar")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          color = color == Colors.green ? Colors.red : Colors.green;
                        });
                        debugPrint("change color");
                      },
                      child: Text("Cambiar color")),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          int min = 1;
                          int max = 10;
                          int selection = min + (Random().nextInt(max - min));
                          strokeWidth = selection.roundToDouble();
                          debugPrint("change stroke width to $selection");
                        });
                      },
                      child: Text("Mayor Grosor")),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}