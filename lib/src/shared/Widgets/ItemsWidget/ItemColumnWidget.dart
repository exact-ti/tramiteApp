import 'package:flutter/material.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class ItemColumnWidget extends StatelessWidget {
  final IconData iconPrimary;
  final dynamic itemIndice;
  final ValueChanged<dynamic> methodAction;
  final Color colorItem;
  final String titulo;
  final String secondTitulo;
  final String subSecondTitulo;
  final String thirdTitulo;
  final String subThirdtitulo;
  final double itemHeight;

  const ItemColumnWidget(
      {Key key,
      @required this.itemHeight,
      @required this.iconPrimary,
      @required this.itemIndice,
      @required this.methodAction,
      @required this.colorItem,
      @required this.titulo,
      @required this.secondTitulo,
      @required this.thirdTitulo,
      @required this.subSecondTitulo,
      this.subThirdtitulo})
      : super(key: key);

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
              methodAction(itemIndice);
            },
            child: Container(
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
              height: itemHeight,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(child: Icon(iconPrimary)),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: Text(
                            "$titulo",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          )),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          height: itemHeight,
                          child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.bottomCenter,
                                  height: 40,
                                  child: Text("$secondTitulo",
                                      style: TextStyle(fontSize: 9)),
                                ),
                                Center(
                                  child: Container(
                                      height: 40,
                                      child: Text("$subSecondTitulo",
                                          style: TextStyle(fontSize: 11))),
                                )
                              ])),
                      flex: 3,
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                            height: itemHeight,
                            child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      height: 40,
                                      child: Text("$thirdTitulo",
                                          style: TextStyle(fontSize: 9)),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                        height: 40,
                                        child: Text("$subThirdtitulo",
                                            style: TextStyle(fontSize: 11))),
                                  )
                                ])),
                      ),
                      flex: 3,
                    ),
                  ]),
            )));
  }
}
