import 'package:dio/dio.dart';
import 'package:tramiteapp/src/Entity/Buzon.dart';
import 'package:tramiteapp/src/Providers/buzones/IBuzonProvider.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

class BuzonProvider implements IBuzonProvider {
  
  Requester req = Requester();


  @override
  Future<List<Buzon>> listarBuzonesDelUsuarioAutenticado() async {
    Response resp = await req.get('/buzones/buzones');
    List<Buzon> buzones = resp.data;
    return buzones;
  }

}