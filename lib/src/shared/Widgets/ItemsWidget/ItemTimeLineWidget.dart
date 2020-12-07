import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tramiteapp/src/styles/Icon_style.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class ItemTimeLineWidget extends StatelessWidget {
  final IconData iconTitulo;
  final IconData iconSubtitulo;
  final IconData iconSubSecondtitulo;
  final IconData iconSubThirdtitulo;
  final IconData iconSubFourthtitulo;
  final dynamic itemIndice;
  final String titulo;
  final String subtitulo;
  final String subSecondtitulo;
  final String subThirdtitulo;
  final String subfourthtitulo;
  final TextStyle styleSubThirdtitulo;
  final TextStyle styleSubFourthtitulo;
  final dynamic modal;
  final Function(dynamic, dynamic) actionWidget;

  const ItemTimeLineWidget(
      {Key key,
      @required this.iconTitulo,
      @required this.iconSubtitulo,
      @required this.iconSubSecondtitulo,
      @required this.iconSubThirdtitulo,
      @required this.itemIndice,
      @required this.titulo,
      @required this.subtitulo,
      @required this.subSecondtitulo,
      @required this.subThirdtitulo,
      @required this.styleSubThirdtitulo,
      @required this.actionWidget,
      @required this.modal,
      this.iconSubFourthtitulo,
      this.subfourthtitulo,
      this.styleSubFourthtitulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TimelineTile(
        alignment: TimelineAlign.start,
        beforeLineStyle: const LineStyle(
          color: Colors.grey,
          thickness: 3,
        ),
        endChild: Container(
          margin: const EdgeInsets.only(bottom: 20, top: 20, left: 10),
          child: Column(
            children: <Widget>[
              titulo == null
                  ? Container()
                  : Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              iconTitulo,
                              size: StylesIconData.ICON_SIZE,
                              color: StylesThemeData.ICON_COLOR,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(titulo,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 12))))
                        ],
                      ),
                    ),
              subtitulo == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              iconSubtitulo,
                              size: StylesIconData.ICON_SIZE,
                              color: StylesThemeData.ICON_COLOR,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(subtitulo,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 12))))
                        ],
                      ),
                    ),
              subSecondtitulo == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              iconSubSecondtitulo,
                              size: StylesIconData.ICON_SIZE,
                              color: StylesThemeData.ICON_COLOR,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(subSecondtitulo,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 12))))
                        ],
                      ),
                    ),
              subfourthtitulo == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              iconSubFourthtitulo,
                              size: StylesIconData.ICON_SIZE,
                              color: StylesThemeData.ICON_COLOR,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      StringUtils.capitalize(subfourthtitulo),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: styleSubFourthtitulo)))
                        ],
                      ),
                    ),
              subThirdtitulo == null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        actionWidget(itemIndice, modal);
                      },
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                iconSubThirdtitulo,
                                size: StylesIconData.ICON_SIZE,
                                color: StylesThemeData.ICON_COLOR,
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(subThirdtitulo,
                                    style: styleSubThirdtitulo))
                          ],
                        ),
                      )),
            ],
          ),
        ),
        indicatorStyle: IndicatorStyle(
          height: 40,
          drawGap: true,
          width: 40,
          indicator: Container(
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFF22C0E8), width: 3.0),
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
