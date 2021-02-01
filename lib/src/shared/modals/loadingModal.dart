import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showModal2(BuildContext context) {
  Widget alert = WillPopScope(
      // ignore: missing_return
      onWillPop: () {},
      child: AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
          ],
        ),
      ));
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
