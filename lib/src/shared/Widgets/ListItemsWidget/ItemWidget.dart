import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class ItemWidget extends StatelessWidget {
  final IconData iconPrimary;
  final IconData iconSend;
  final dynamic itemIndice;
  final ValueChanged<dynamic> methodAction;
  final Color colorItem;
  final String titulo;
  final String subtitulo;
  final String subSecondtitulo;
  final TextStyle styleTitulo;
  final TextStyle styleSubTitulo;
  final TextStyle styleSubSecondtitulo;
  final IconData iconSubSecondtitulo;
  final Color iconColor;

  const ItemWidget(
      {Key key,
      @required this.iconPrimary,
      @required this.iconSend,
      @required this.itemIndice,
      @required this.methodAction,
      @required this.colorItem,
      @required this.titulo,
      @required this.subtitulo,
      @required this.subSecondtitulo,
      @required this.styleTitulo,
      @required this.styleSubTitulo,
      @required this.styleSubSecondtitulo,
      @required this.iconColor,
      this.iconSubSecondtitulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorItem,
          border: itemIndice == 0
              ? Border(
                  top: BorderSide(width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                  bottom:
                      BorderSide(width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                )
              : Border(
                  bottom:
                      BorderSide(width: 0.8, color: StylesThemeData.ITEM_LINE_COLOR),
                ),
        ),
        child: InkWell(
            onTap: () {
              methodAction(itemIndice);
            },
            child: Container(
              child: Row(children: <Widget>[
                Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: 20),
                    height: 70,
                    child: iconPrimary != null
                        ? Center(
                            child: FaIcon(
                            iconPrimary,
                            color: iconColor,
                            size: 25,
                          ))
                        : Container()),
                Expanded(
                  child: Container(
                      height: 70,
                      child: Column(children: <Widget>[
                        titulo == null
                            ? Container()
                            : Expanded(
                                child: Center(
                                    child: Container(
                                padding: EdgeInsets.only(left: 30),
                                alignment: Alignment.centerLeft,
                                child: Text("$titulo", style: styleTitulo),
                              ))),
                        subtitulo == null
                            ? Container()
                            : Expanded(
                                child: Center(
                                    child: Container(
                                padding: EdgeInsets.only(left: 30),
                                alignment: Alignment.centerLeft,
                                child:
                                    Text("$subtitulo", style: styleSubTitulo),
                              ))),
                        subSecondtitulo ==null
                            ? Container()
                            : Expanded(
                                child: iconSubSecondtitulo != null
                                    ? Container(
                                        height: 20,
                                        child: ListTile(
                                          title: Text("$subSecondtitulo"),
                                          leading: Icon(
                                            iconSubSecondtitulo,
                                            color: iconColor,
                                          ),
                                        ))
                                    : Center(
                                        child: Container(
                                        padding: EdgeInsets.only(left: 30),
                                        alignment: Alignment.centerLeft,
                                        child: Text("$subSecondtitulo",
                                            style: styleSubSecondtitulo),
                                      ))),
                      ])),
                  flex: 3,
                ),
                Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 70,
                    child: iconSend != null
                        ? Center(
                            child: FaIcon(
                            iconSend,
                            color: iconColor,
                            size: 30,
                          ))
                        : Container()),
              ]),
            )));
  }
}
