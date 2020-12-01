import 'package:flutter/material.dart';

class SnackBarWidget extends StatelessWidget {
  final String mensaje;
  final Color color;

  const SnackBarWidget({
    Key key,
    @required this.mensaje,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: new Text(this.mensaje),
      backgroundColor: this.color,
    );
  }
}
