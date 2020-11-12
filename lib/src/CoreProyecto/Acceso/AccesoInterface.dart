import 'package:flutter/cupertino.dart';

abstract class AccesoInterface {

    Future<Map<String, dynamic>> login(String username, String password,BuildContext context);

}
