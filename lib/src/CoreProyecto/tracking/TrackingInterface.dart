import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';

abstract class TrackingInterface {
    Future<TrackingModel> mostrarTracking(int codigo);
}
