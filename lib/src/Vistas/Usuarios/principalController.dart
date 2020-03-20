
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/usuario/UsuarioInterface.dart';
import 'package:tramiteapp/src/ModelDto/UsuarioFrecuente.dart';
import 'package:tramiteapp/src/Providers/usuarios/impl/UsuarioProvider.dart';

class PrincipalController {
    UsuarioInterface usuarioInterface = new UsuarioImpl( new UsuarioProvider());
    
    Future<List<UsuarioFrecuente>>  listarusuariosfrecuentes() async {
       List<UsuarioFrecuente> usuarios =  await usuarioInterface.listarUsuariosFrecuentes();
        return usuarios;
    }

  List<UsuarioFrecuente>  ListarDestinario(String text) {


    var tamano = text.length; 

    if(tamano == 0){
        return null;
    } 

    final dato1 = {
      'nombre' : 'Orlando Heredia',
      'area' : 'Proyectos TI',
    };

    final dato2 = {
      'nombre' : 'Crhistian Campos',
      'area' : 'Proyectos TI',
    };

        final dato3 = {
      'nombre' : 'Sebastian vilela',
      'area' : 'Comercial',
    };
        final dato4 = {
      'nombre' : 'Kelly Salazar',
      'area' : 'Administración',
    };
        final dato5 = {
      'nombre' : 'Genesis Grossi',
      'area' : 'Recursos Humanos',
    };
        final dato6 = {
      'nombre' : 'Ivonne Contreras',
      'area' : 'Proyectos Procesos',
    };
        final dato7 = {
      'nombre' : 'Jorge Herrera',
      'area' : 'Gerencia Operación',
    };
        final dato8 = {
      'nombre' : 'Sonia Portugal',
      'area' : 'Gerencia General',
    };
        final dato9 = {
      'nombre' : 'Ronald Santos',
      'area' : 'Ex trabajador',
    };
        final dato10 = {
      'nombre' : 'Ernest Rojas',
      'area' : 'Supervisor BCP',
    };
        final dato11 = {
      'nombre' : 'Bryan Meza',
      'area' : 'Supervisor ATE',
    };
        final dato12 = {
      'nombre' : 'Pablo Viar',
      'area' : 'Operativo Mexico',
    };
        final dato13 = {
      'nombre' : 'Alan Garcia',
      'area' : 'Gerente BCP',
    };

    final dato14 = {
      'nombre' : 'Cesar Baltazar',
      'area' : 'Proyectos TI',
    };

    final dato15 = {
      'nombre' : 'Omar Cevallos',
      'area' : 'Supervisor Marsh',
    };

    final dato16 = {
      'nombre' : 'Karina Hinostroza',
      'area' : 'Recursos Humanos',
    };

    final dato17 = {
      'nombre' : 'Olinda Benites',
      'area' : 'Trabajadora Social',
    };

        

      List<Map<String,dynamic>> myList = List<Map<String,dynamic>>();
        myList.add(dato1);
        myList.add(dato2);
        myList.add(dato3);
        myList.add(dato4);
        myList.add(dato5);
        myList.add(dato6);
        myList.add(dato7);
        myList.add(dato8);
        myList.add(dato9);
        myList.add(dato10);
        myList.add(dato11);
        myList.add(dato12);
        myList.add(dato13);
        myList.add(dato14);
        myList.add(dato15);
        myList.add(dato16);
        myList.add(dato17);

      List<Map<String,dynamic>> listarfiltrados = List<Map<String,dynamic>>();

    
      for(Map<String,dynamic> onlylist in myList){
         if(onlylist["nombre"].toString().substring(0,tamano).toLowerCase() == text.toLowerCase()){
            listarfiltrados.add(onlylist);
         } 
      }

        List<UsuarioFrecuente> listarfiltradoss = List<UsuarioFrecuente>();
        return listarfiltradoss;
    }


}