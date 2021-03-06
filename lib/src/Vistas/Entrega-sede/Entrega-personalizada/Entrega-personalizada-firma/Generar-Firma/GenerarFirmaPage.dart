import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Entrega-sede/Entrega-personalizada/Entrega-personalizada-firma/Registrar-firma/RegistrarEntregaPersonalizadaPage.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class GenerarFirmaPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GenerarFirmaPage> {
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  void initState() {
    super.initState();
  }

  void onPressClearButton() {
    final sign = _sign.currentState;
    sign.clear();
  }

  void onPressSaveButton() async {
    final sign = _sign.currentState;
    final image = await sign.getData();
    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    sign.clear();
    final encoded = base64.encode(data.buffer.asUint8List());
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RegistrarEntregapersonalizadoPage(firma: encoded),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final botonesinferiores = Row(children: [
      Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 1, right: 1),
            child: ButtonWidget(
                iconoButton: IconsData.ICON_SAVE,
                onPressed: onPressSaveButton,
                colorParam: StylesThemeData.PRIMARY_COLOR,
                texto: "Guardar")),
      ),
      Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 1, right: 1),
            child: ButtonWidget(
                iconoButton: IconsData.ICON_CLEAR,
                onPressed: onPressClearButton,
                colorParam: StylesThemeData.BUTTON_SECUNDARY_COLOR,
                texto: 'Limpiar')),
      ),
    ]);

    return Scaffold(
        appBar: CustomAppBar(text: "Entrega personalizada"),
        backgroundColor: Colors.white,
        body: scaffoldbody(
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: FaIcon(
                          IconsData.ICON_CLOSE,
                          color: StylesThemeData.ICON_COLOR,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  Expanded(
                    child: Container(
                      child: Signature(
                        color: color,
                        key: _sign,
                        onSign: () {
                          final sign = _sign.currentState;
                          debugPrint(
                              '${sign.points.length} points in the signature');
                        },
                        strokeWidth: strokeWidth,
                      ),
                      color: Colors.black12,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: botonesinferiores,
                  )
                ],
              ),
            ),
            context));
  }
}
