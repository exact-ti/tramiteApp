import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';

class ListItemWidget extends StatelessWidget {
  final Widget Function(dynamic) itemWidget;
  final List<dynamic> listItems;
  final String mensajeEmpty;

  const ListItemWidget({
    Key key,
    @required this.itemWidget,
    @required this.listItems,
    this.mensajeEmpty
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: Container(
        child: listItems.isEmpty
            ? Container(
                child: Center(
                    child: sinResultados(this.mensajeEmpty==null? "No se han encontrado resultados":mensajeEmpty,
                        IconsData.ICON_ERROR_EMPTY)))
            : ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, i) => itemWidget(i)),
      ),
    ));
  }
}
