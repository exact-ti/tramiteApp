import 'package:tramiteapp/src/Entity/Buzon.dart';

abstract class IBuzonProvider{
  Future<List<Buzon>> listarBuzonesDelUsuarioAutenticado();
}