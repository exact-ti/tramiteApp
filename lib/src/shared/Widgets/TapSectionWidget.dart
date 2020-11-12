import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class TabSectionWidget extends StatelessWidget {
  final IconData iconPrimerTap;
  final IconData iconSecondTap;
  final String namePrimerTap;
  final String nameSecondTap;
  final List<dynamic> listPrimerTap;
  final List<dynamic> listSecondTap;
  final Widget Function(dynamic) itemPrimerTapWidget;
  final Widget Function(dynamic) itemSecondTapWidget;
  final int initstateIndex;
  final Function(dynamic) onTapTabSection;

  const TabSectionWidget({
    Key key,
    @required this.iconPrimerTap,
    @required this.iconSecondTap,
    @required this.namePrimerTap,
    @required this.nameSecondTap,
    @required this.listPrimerTap,
    @required this.listSecondTap,
    @required this.itemPrimerTapWidget,
    @required this.itemSecondTapWidget,
    this.onTapTabSection,
    this.initstateIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return initstateIndex == null
        ? Container(child: loadingGet())
        : DefaultTabController(
            length: 2,
            initialIndex: initstateIndex == null ? 0 : initstateIndex,
            child: Builder(builder: (BuildContext context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  if (onTapTabSection != null) {
                    onTapTabSection(tabController.index);
                  }
                }
              });
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
                        onTap: (index) {
                          if (onTapTabSection != null) {
                            onTapTabSection(index);
                          }
                        },
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
                        child: listPrimerTap == null
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loadingGet(),
                              ))
                            : listPrimerTap.isEmpty
                                ? sinResultados(
                                    "No se han encontrado resultados",
                                    IconsData.ICON_ERROR_EMPTY)
                                : ListView.builder(
                                    itemCount: listPrimerTap.length,
                                    itemBuilder: (context, i) =>
                                        itemPrimerTapWidget(i)),
                      ),
                      Container(
                        child: listSecondTap == null
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loadingGet(),
                              ))
                            : listSecondTap.isEmpty
                                ? sinResultados(
                                    "No se han encontrado resultados",
                                    IconsData.ICON_ERROR_EMPTY)
                                : ListView.builder(
                                    itemCount: listSecondTap.length,
                                    itemBuilder: (context, i) =>
                                        itemSecondTapWidget(i)),
                      ),
                    ]),
                  ),
                ],
              );
            }),
          );
  }
}
