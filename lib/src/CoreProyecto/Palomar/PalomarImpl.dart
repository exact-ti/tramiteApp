import 'package:tramiteapp/src/Providers/palomares/IPalomarProvider.dart';
import 'PalomarInterface.dart';




class PalomarImpl implements PalomarInterface {
  
  IPalomarProvider palomar;

  PalomarImpl(IPalomarProvider palomar){
    this.palomar = palomar;
  }

  @override
  Future<dynamic> listarPalomarByCodigo(String codigo) async {
     dynamic palomarModel = await palomar.listarPalomarByCodigo(codigo) ;
      return palomarModel;
  }

}
