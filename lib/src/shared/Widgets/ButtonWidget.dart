import 'package:flutter/material.dart';
import 'package:tramiteapp/src/styles/Icon_style.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color colorParam;
  final String texto;
  final IconData iconoButton;

  const ButtonWidget({
    Key key,
    @required this.onPressed,
    @required this.colorParam,
    @required this.texto,
    this.iconoButton,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              iconoButton==null?Container():Container(child:Icon(iconoButton,color: Colors.white,size: StylesIconData.ICON_SIZE,), margin: EdgeInsets.only(right: 10),),
              Text(this.texto, style: TextStyle(color: Colors.white))
            ],
          )),
    ));
  }
}
