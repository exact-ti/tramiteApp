import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';

abstract class INotificacionProvider{
  Future<List<NotificacionModel>> listarNotificacionesPendientes();
}