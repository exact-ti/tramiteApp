import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Color colorParam;
  final String texto;

  const CustomButton({
    Key key,
    @required this.onPressed,
    @required this.colorParam,
    @required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ButtonTheme(
          minWidth: 130.0,
          height: 45.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: onPressed,
              color: this.colorParam,
              child:
                  Text(this.texto, style: TextStyle(color: Colors.white))),
        ));
  }
}
