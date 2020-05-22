
import 'package:flutter/cupertino.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/Palomar/PalomarInterface.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/ModelDto/palomarModel.dart';
import 'package:tramiteapp/src/Providers/palomares/impl/PalomarProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';

class ClasificacionController {
  
    PalomarInterface usuarioInterface = new PalomarImpl( new PalomarProvider());

    Future<List<PalomarModel> >  listarpalomarByCodigo(BuildContext context, String codigo) async {
        List<PalomarModel> palomares = new List();
       PalomarModel palomar=  await usuarioInterface.listarPalomarByCodigo(codigo);
       if(palomar == null){
            mostrarAlerta(context,"El sobre no existe en la base de datos", "Codigo incorrecto");
            return null;
       }
        palomares.add(palomar);    
        return palomares;
    }

}