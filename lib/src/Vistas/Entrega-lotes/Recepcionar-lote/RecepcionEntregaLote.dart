
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/ModelDto/EntregaLote.dart';

class RecepcionEntregaLotePage extends StatefulWidget {
  final EntregaLoteModel entregaLotepage;

  const RecepcionEntregaLotePage({Key key, this.entregaLotepage}) : super(key: key);

  @override
  _RecepcionEntregaLotePageState createState() =>
      new _RecepcionEntregaLotePageState(entregaLotepage);
}

class _RecepcionEntregaLotePageState extends State<RecepcionEntregaLotePage> {

  EntregaLoteModel entregaLote;
  _RecepcionEntregaLotePageState(this.entregaLote);

  @override
  Widget build(BuildContext context) {

  }
}