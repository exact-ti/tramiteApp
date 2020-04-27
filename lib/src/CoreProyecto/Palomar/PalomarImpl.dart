import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:tramiteapp/src/Providers/palomares/IPalomarProvider.dart';
import 'PalomarInterface.dart';




class PalomarImpl implements PalomarInterface {
  
  IPalomarProvider palomar;

  PalomarImpl(IPalomarProvider palomar){
    this.palomar = palomar;
  }

  @override
  Future<PalomarModel> listarPalomarByCodigo(String codigo) async {
     PalomarModel palomarModel = await palomar.listarPalomarByCodigo2(codigo) ;
      return palomarModel;
  }

}
