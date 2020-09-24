import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'NotificacionesController.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  NotificacionController notificacioncontroller = new NotificacionController();
  NotificacionModel notificacionModel = new NotificacionModel();
  @override
  void initState() {
    gestionNotificaciones();
    super.initState();
  }

  retrieveData(){
    setState(() {
      notificacionModel=notificacionModel;
    });
  }

    void gestionNotificaciones() async {
    List<NotificacionModel> listanotificacionesPendientes =
        await notificacioncontroller.listarNotificacionesPendientes();
    if (this.mounted) {
        Provider.of<NotificationInfo>(context, listen: false)
                .cantidadNotificacion =
            listanotificacionesPendientes
                .where((element) =>
                    element.notificacionEstadoModel.id == pendiente)
                .toList()
                .length;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(NotificacionModel notificacionModel) {
      return InkWell(
      onTap: () async{
        dynamic respuestaController = await notificacioncontroller.visitarNotificacion(notificacionModel.id);
        if(respuestaController["status"]=="success"){
          Navigator.pushNamed(context, notificacionModel.ruta).whenComplete(retrieveData());
        /* Navigator.of(context).pushNamed(notificacionModel.ruta); */
        }else{
          notificacion(context, "error", "EXACT", "Surgió un problema");
        }
      }, // handle your onTap here
      child:Container(
          height: 70,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: /* notificacionModel.notificacionEstadoModel.id!=visitado?colorplomo: */Colors.white,
              border: new Border(bottom: BorderSide(color: Colors.grey[300])),
              ),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(notificacionModel.mensaje,overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[300])))),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(notificacionModel.fecha,
                          style: TextStyle(
                              fontSize: 15, color: Color(0xFFACADAD)))))
            ],
          )));
    }

    Widget _crearListado(notificacionModel) {
      return FutureBuilder(
          future: notificacioncontroller.listarNotificacionesPendientes(),
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificacionModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sinResultados("No hay conexión con el servidor");
              case ConnectionState.waiting:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadingGet(),
                ));
              default:
                if (snapshot.hasError) {
                  return sinResultados("Ha surgido un problema");
                } else {
                  if (snapshot.hasData) {
                    final notificaciones = snapshot.data;
                    if (notificaciones.length == 0) {
                      return sinResultados("No hay notificaciones pendientes");
                    } else {
                      return ListView.builder(
                          itemCount: notificaciones.length,
                          itemBuilder: (context, i) =>
                              crearItem(notificaciones[i]));
                    }
                  } else {
                    return sinResultados("No hay notificaciones pendientes");
                  }
                }
            }
          });
    }

    Widget mainscaffold() {
      return 
          Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: _crearListado(notificacionModel)),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text("Notificaciones",
                style: TextStyle(
                    fontSize: 18,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal))),
        body: scaffoldbody(mainscaffold(), context));
  }
}
