import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/ITrackingProvider.dart';

import 'TrackingInterface.dart';

class TrackingImpl implements TrackingInterface {
  
  ITrackingProvider trackingProvider;

  TrackingImpl(ITrackingProvider trackingProvider) {
    this.trackingProvider = trackingProvider;
  }

  @override
  Future<TrackingModel> mostrarTracking(String codigo) async{
     TrackingModel tracking = await trackingProvider.mostrarTracking2(codigo);
        return tracking;
  }

}