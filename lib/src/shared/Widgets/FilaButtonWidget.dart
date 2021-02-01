import 'package:flutter/material.dart';

class FilaButtonWidget extends StatelessWidget {
  final Widget firsButton;
  final Widget secondButton;

  const FilaButtonWidget({
    Key key,
    @required this.firsButton,
    this.secondButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(flex: 5, child: firsButton),
        Expanded(
            flex: 5,
            child: secondButton != null
                ? Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: secondButton,
                  )
                : Container())
      ],
    ));
  }
}
