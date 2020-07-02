import 'dart:convert';

import 'package:tramiteapp/src/Entity/TipoBuzon.dart';

String menuToJson(Buzon data) => json.encode(data.toJson());


class Buzon {
  int id;
  String nombre;
  TipoBuzon tipoBuzon;

      Map<String, dynamic> toJson() => {
        "id"         : id,
        "nombre"     : nombre,
        "TipoBuzon"      : tipoBuzon,           
    };
}


