import 'package:flutter/material.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class CustomSwitch extends StatelessWidget {
  final VoidCallback onPressed;
  final bool switchValue;
  final String textEnabled;
  final String textDisabled;
  const CustomSwitch({
    Key key,
    @required this.onPressed,
    @required this.switchValue,
    @required this.textEnabled,
    @required this.textDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Center(
          child: Switch(
            value: switchValue,
            onChanged: (value) {
              onPressed();
            },
            activeTrackColor: StylesThemeData.SWITCHCOLOR,
            activeColor: StylesThemeData.PRIMARYCOLOR,
          ),
        ),
        Expanded(
          child: Container(
            child: switchValue != true ? Text(textEnabled) : Text(textDisabled),
          ),
          flex: 3,
        )
      ]),
    );
  }
}
