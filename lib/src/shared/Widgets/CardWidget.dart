import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class CardWidget extends StatelessWidget {
  final Color colorCart;
  final IconData iconSuperior;
  final dynamic infoMap;

  const CardWidget({
    Key key,
    @required this.colorCart,
    @required this.iconSuperior,
    @required this.infoMap,
  }) : super(key: key);

  List<Widget> listWidget(dynamic listmap) {
    List<Widget> listInformation = new List();
    listmap.forEach((clave, valor) {
      if (valor != '') {
        listInformation.add(
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                   Expanded(
                    child:Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.bottomLeft,
                      child: Text('$clave',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                    flex: 3,),
                  Expanded(
                    child: Text(valor,
                        style: TextStyle(color: StylesThemeData.LETTER_COLOR)),
                    flex: 3,
                  ),
                ],
              )),
        );
      }
    });

    return listInformation;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        child: new Stack(
          children: <Widget>[
            Card(
                borderOnForeground: true,
                elevation: 5,
                shadowColor: StylesThemeData.ITEM_LINE_COLOR,
                semanticContainer: true,
                color: colorCart,
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 10, top: 20, left: 10, bottom: 10),
                      child: Container(
                        child: Column(
                          children: listWidget(infoMap),
                        ),
                      ),
                    ))),
            FractionalTranslation(
              translation: Offset(0.0, -0.4),
              child: iconSuperior != null
                  ? Align(
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: StylesThemeData.PRIMARY_COLOR,
                        child: Icon(
                          iconSuperior,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      alignment: FractionalOffset(0.5, 0.0),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
