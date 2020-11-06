import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/icon_style.dart';

class ItemWidget extends StatelessWidget {
  final IconData iconPrimary;
  final IconData iconSend;
  final dynamic itemIndice;
  final ValueChanged<dynamic> methodAction;
  final ValueChanged<dynamic> onPressedCode;
  final Color colorItem;
  final String titulo;
  final String subtitulo;
  final String subSecondtitulo;
  final String subThirdtitulo;
  final String subFourtitulo;
  final String subFivetitulo;
  final TextStyle styleTitulo;
  final TextStyle styleSubTitulo;
  final TextStyle styleSubSecondtitulo;
  final IconData iconSubSecondtitulo;
  final Color iconColor;
  final double itemHeight;

  const ItemWidget(
      {Key key,
      @required this.itemHeight,
      @required this.itemIndice,
      @required this.colorItem,
      @required this.titulo,
      this.iconPrimary,
      this.iconSend,
      this.methodAction,
      this.subtitulo,
      this.subSecondtitulo,
      this.styleTitulo,
      this.styleSubTitulo,
      this.styleSubSecondtitulo,
      this.iconColor,
      this.onPressedCode,
      this.subThirdtitulo,
      this.subFourtitulo,
      this.iconSubSecondtitulo,
      this.subFivetitulo})
      : super(key: key);

  Widget contenidoWidget() {
    return Container(
      child: Row(children: <Widget>[
        Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(left: 20),
            height: itemHeight,
            child: iconPrimary != null
                ? Center(
                    child: FaIcon(
                    iconPrimary,
                    color: iconColor,
                    size: StylesIconData.ICON_SIZE,
                  ))
                : Container()),
        Expanded(
          child: Container(
              height: itemHeight,
              child: Column(children: <Widget>[
                titulo == null
                    ? Container()
                    : Expanded(
                        child: Center(
                            child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 0),
                            alignment: Alignment.centerLeft,
                            child: Text("$titulo", style: styleTitulo),
                          ),
                          subThirdtitulo != null
                              ? Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "$subThirdtitulo",
                                        style: styleSubTitulo,
                                      )))
                              : Container()
                        ],
                      ))),
                subtitulo == null
                    ? Container()
                    : Expanded(
                        child: Center(
                            child: Row(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 0),
                          alignment: Alignment.centerLeft,
                          child: Text("$subtitulo", style: styleSubTitulo),
                        ),
                        subFourtitulo != null
                            ? Expanded(
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("$subFourtitulo",
                                        style: styleSubTitulo)))
                            : Container()
                      ]))),
                subSecondtitulo == null
                    ? Container()
                    : Expanded(
                        child: Center(
                            child: Row(
                        children: <Widget>[
                          iconSubSecondtitulo != null
                              ? Container(
                                  height: 20,
                                  child: ListTile(
                                    title: onPressedCode == null
                                        ? Text("$subSecondtitulo",
                                            style: styleSubSecondtitulo)
                                        : InkWell(
                                            onTap: () {
                                              onPressedCode(itemIndice);
                                            },
                                            child: Text("$subSecondtitulo",
                                                style: styleSubSecondtitulo),
                                          ),
                                    leading: Icon(
                                      iconSubSecondtitulo,
                                      color: iconColor,
                                    ),
                                  ))
                              : Center(
                                  child: Container(
                                  padding: EdgeInsets.only(left: 0),
                                  alignment: Alignment.centerLeft,
                                  child: onPressedCode == null
                                      ? Text(
                                          "$subSecondtitulo",
                                          style: styleSubSecondtitulo,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            onPressedCode(itemIndice);
                                          },
                                          child: Text("$subSecondtitulo",
                                              style: styleSubSecondtitulo),
                                        ),
                                )),
                          subFivetitulo != null
                              ? Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text("$subFivetitulo",
                                          style: styleSubTitulo)))
                              : Container()
                        ],
                      ))),
              ])),
          flex: 3,
        ),
        Container(
            margin: EdgeInsets.only(right: 20),
            height: itemHeight,
            child: iconSend != null
                ? Center(
                    child: FaIcon(
                    iconSend,
                    color: iconColor,
                    size: StylesIconData.ICON_SIZE,
                  ))
                : Container()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorItem,
          border: itemIndice == 0
              ? Border(
                  top: BorderSide(
                      width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                  bottom: BorderSide(
                      width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                )
              : Border(
                  bottom: BorderSide(
                      width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                ),
        ),
        child: InkWell(
            onTap: () {
              if (methodAction != null) methodAction(itemIndice);
            },
            child: contenidoWidget()));
  }
}
