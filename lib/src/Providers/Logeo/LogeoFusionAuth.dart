import 'package:tramiteapp/src/Providers/Logeo/LogeoInterface.dart';
import 'package:tramiteapp/src/Requester/Requester.dart';

class LogeoFusionAuth implements LogeoInterface {

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    Requester req = Requester();
    final resp = await req.login("/servicio-auth/auth", username,password);
    Map<String, dynamic> decodedResp = resp.data;
    return decodedResp;
  }
}
