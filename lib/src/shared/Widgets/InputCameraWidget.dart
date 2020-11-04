import 'package:flutter/material.dart';

class InputCameraWidget extends StatelessWidget {
  final IconData iconData;
  final Widget inputParam;
  final VoidCallback onPressed;
  final String title;

  const InputCameraWidget(
      {Key key,
      this.iconData,
      this.onPressed,
      @required this.inputParam,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      title != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 5, top: 10),
              child: Text(title, style: TextStyle(fontSize: 15)),
            )
          : Container(),
      Container(
          margin: title == null ? const EdgeInsets.only(top: 10) : null,
          alignment: Alignment.center,
          width: double.infinity,
          child: Row(children: <Widget>[
            Expanded(
              child: inputParam,
              flex: 5,
            ),
            Expanded(
                child: iconData != null
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: IconButton(
                              icon: Icon(iconData),
                              tooltip: "Increment",
                              onPressed: onPressed),
                        ))
                    : Opacity(
                        opacity: 0.0,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Icon(Icons.camera_alt),
                        ))),
          ]))
    ]);
  }
}
