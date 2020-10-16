import 'package:tramiteapp/src/Providers/perfiles/IPerfilProvider.dart';
import 'IPerfilCore.dart';

class PerfilCore implements IPerfilCore {

  IPerfilProvider perfilProvider;

  PerfilCore(IPerfilProvider perfilProvider) {
    this.perfilProvider = perfilProvider;
  }

  @override
  Future listarTipoPerfil() async {
    dynamic resp = await perfilProvider.listarTipoPerfilByPerfil();
    return resp;
  }
}
