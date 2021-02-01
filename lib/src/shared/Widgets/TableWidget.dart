import 'package:flutter/material.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class TableWidget extends StatelessWidget {
  final Color colorHeader;
  final List<String> listTitles;
  final List<List<Widget>> listRow;

  const TableWidget({
    Key key,
    @required this.colorHeader,
    @required this.listTitles,
    @required this.listRow,
  }) : super(key: key);

  Widget listHeaders() {
    List<Widget> titlesWidget = listTitles.map((title) {
      return Expanded(
          child: Container(
        alignment: Alignment.center,
        height: 60.0,
        margin: const EdgeInsets.all(0),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ));
    }).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: titlesWidget,
    );
  }

  Widget listRows() {
    List<Widget> rowsWidget = listRow.map((row) {
      List<Widget> rowsData = row.map((data) => Expanded(
          child: Container(
        alignment: Alignment.center,
        height: 60.0,
        decoration: BoxDecoration(
                                border: Border(
                                bottom: BorderSide(
                                    width: 1.5, color: Colors.grey[200])
                                ),
                              ),
        margin: const EdgeInsets.all(0),
        child: data /* Text(
          data,
          style: TextStyle(color: Colors.black),
        ) */,
      ))).toList();
      return  Row(
        children: rowsData,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowsWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 5,
          color: StylesThemeData.PRIMARY_COLOR,
          child: Container(child: listHeaders()),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: listRows(),
          ),
        )
      ],
    ));
  }
}
