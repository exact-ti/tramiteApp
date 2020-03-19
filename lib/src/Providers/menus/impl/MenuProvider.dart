import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

import '../IMenuProvider.dart';


class MenuProvider implements IMenuProvider {
  
  Requester req = Requester();

  Menu menuu = new Menu();

  @override
  Future<List<Menu>> listarMenusDelUsuarioAutenticado() async {
    Response resp = await req.get('/servicio-menu/menus');
    List<dynamic> menus = resp.data;
    List<Menu> listmenu = menuu.fromJson(menus);
    return listmenu;
  }

}