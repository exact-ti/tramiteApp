import 'package:flutter/material.dart';

class InputCamera extends StatelessWidget {
  final IconData iconData;
  final Widget inputParam;
  final VoidCallback onPressed;

  const InputCamera({
    Key key,
    @required this.iconData,
    @required this.onPressed,
    @required this.inputParam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Row(children: <Widget>[
          Expanded(
            child: inputParam,
            flex: 5,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: new IconButton(
                  icon: Icon(iconData),
                  tooltip: "Increment",
                  onPressed: onPressed),
            ),
          ),
        ]));
  }
}
