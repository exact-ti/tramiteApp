import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Menu.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';
import '../IMenuProvider.dart';


class MenuProvider implements IMenuProvider {
  
  Requester req = Requester();

  Menu menuclase = new Menu();

  @override
  Future<List<Menu>> listarMenusDelUsuarioAutenticado() async {
    int id = 1;
    Response resp = await req.get('/servicio-menu/menus?tipoClienteId=$id');
    return menuclase.fromJson(resp.data);
  }

}