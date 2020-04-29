
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';


abstract class ITrackingProvider{
 
  Future<TrackingModel> mostrarTracking(String codigo); 


  Future<TrackingModel> mostrarTracking2(String codigo);   

}