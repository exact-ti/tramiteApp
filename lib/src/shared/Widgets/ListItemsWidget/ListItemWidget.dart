import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';

class ListItemWidget extends StatelessWidget {
  final Widget Function(dynamic) itemWidget;
  final List<dynamic> listItems;
  final String mensajeEmpty;
  final bool mostrarMensaje;

  const ListItemWidget(
      {Key key,
      @required this.itemWidget,
      @required this.listItems,
      this.mensajeEmpty,
      this.mostrarMensaje})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: Container(
        child: listItems == null
            ? loadingGet()
            : listItems.isEmpty
                ? Container(
                    child: mostrarMensaje != null && mostrarMensaje != false
                        ? Center(
                            child: sinResultados(
                                this.mensajeEmpty == null
                                    ? "No se han encontrado resultados"
                                    : mensajeEmpty,
                                IconsData.ICON_ERROR_EMPTY))
                        : Container())
                : ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (context, i) => itemWidget(i)),
      ),
    ));
  }
}
