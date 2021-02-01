import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';

class FutureItemWidget extends StatelessWidget {
  final Widget Function(dynamic) itemWidget;
  final Future<List<dynamic>> futureList;
  final Function(List<dynamic>) setList;
  final String mensajeEmpty;
  final Function(List<dynamic>) methodPostFuture;

  const FutureItemWidget(
      {Key key,
      @required this.itemWidget,
      @required this.futureList,
      this.setList,
      this.mensajeEmpty,
      this.methodPostFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
            future: futureList,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return sinResultados("No hay conexión con el servidor",
                      IconsData.ICON_ERROR_SERVIDOR);
                case ConnectionState.waiting:
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadingGet(),
                  ));
                default:
                  if (snapshot.hasError) {
                    return sinResultados(
                        "Ha surgido un problema", IconsData.ICON_ERROR_PROBLEM);
                  } else {
                    if (snapshot.hasData) {
                      if (methodPostFuture != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          methodPostFuture(snapshot.data);
                        });
                      }
                      final listDynamic = snapshot.data;
                      setList(snapshot.data);
                      if (listDynamic.length == 0) {
                        return sinResultados(
                            mensajeEmpty == null
                                ? "No se han encontrado resultados"
                                : mensajeEmpty,
                            IconsData.ICON_ERROR_EMPTY);
                      } else {
                        return ListView.builder(
                            itemCount: listDynamic.length,
                            itemBuilder: (context, i) => itemWidget(i));
                      }
                    } else {
                      return sinResultados(
                          mensajeEmpty == null
                              ? "No se han encontrado resultados"
                              : mensajeEmpty,
                          IconsData.ICON_ERROR_EMPTY);
                    }
                  }
              }
            }),
      ),
    ));
  }
}
