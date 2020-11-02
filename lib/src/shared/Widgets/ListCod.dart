import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/styles/theme_data.dart';

class ListCod extends StatelessWidget {
  final List<EnvioModel> enviosModel;
  final String mensaje;

  const ListCod({
    Key key,
    @required this.enviosModel,
    this.mensaje,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget itemCod(EnvioModel envioModel) {
      return Container(
          decoration: myBoxDecoration(StylesThemeData.LETTERCOLOR),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            title: Text("${envioModel.codigoPaquete}"),
            leading: FaIcon(FontAwesomeIcons.qrcode, color: Color(0xffC7C7C7)),
            trailing: envioModel.estado == null || !envioModel.estado
                ? Text("")
                : Icon(
                    Icons.check,
                    color: StylesThemeData.PRIMARYCOLOR,
                  ),
          ));
    }

    return enviosModel.isEmpty
        ? Container(child: sinResultados(mensaje==null?"":mensaje),)
        : ListView.builder(
            itemCount: this.enviosModel.length,
            itemBuilder: (context, i) => itemCod(this.enviosModel[i]));
  }
}
