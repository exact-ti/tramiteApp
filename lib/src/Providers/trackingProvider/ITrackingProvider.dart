import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';

abstract class ITrackingProvider {
  Future<TrackingModel> mostrarTracking(int codigo);
}
