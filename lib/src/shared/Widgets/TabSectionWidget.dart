import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class TabSectionWidget extends StatelessWidget {
  final IconData iconPrimerTap;
  final IconData iconSecondTap;
  final String namePrimerTap;
  final String nameSecondTap;
  final Widget itemPrimerTapWidget;
  final Widget itemSecondTapWidget;

  const TabSectionWidget({
    Key key,
    @required this.iconPrimerTap,
    @required this.iconSecondTap,
    @required this.namePrimerTap,
    @required this.nameSecondTap,
    @required this.itemPrimerTapWidget,
    @required this.itemSecondTapWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
            length: 2,
            child: Builder(builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.8))),
                    child: TabBar(
                        indicatorColor: StylesThemeData.PRIMARY_COLOR,
                        labelColor: StylesThemeData.PRIMARY_COLOR,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(iconPrimerTap),
                                  SizedBox(width: 20, height: 50),
                                  Text(namePrimerTap)
                                ]),
                          ),
                          Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Icon(iconSecondTap),
                                SizedBox(width: 20, height: 50),
                                Text(nameSecondTap)
                              ])),
                        ]),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      Container(
                        child: itemPrimerTapWidget==null?loadingGet():itemPrimerTapWidget,
                      ),
                      Container(
                        child: itemSecondTapWidget==null?loadingGet():itemSecondTapWidget,
                      ),
                    ]),
                  ),
                ],
              );
            }),
          );
  }
}