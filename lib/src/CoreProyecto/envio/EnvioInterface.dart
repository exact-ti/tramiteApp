import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';

class EnvioInterface {

    void crearEnvio(EnvioModel envioModel){}
    
    Future<bool> validarCodigo(String texto){}

    Future<bool> validarBandejaCodigo(String texto){}

    }


