import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/top-bar/topBarController.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  @override
  final Size preferredSize;
  CustomAppBar({
    @required this.text,
  }) : preferredSize = Size.fromHeight(56.0);

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppBarState();
  }
}

class _CustomAppBarState extends State<CustomAppBar>
    with WidgetsBindingObserver {
  TopBarController topBarController = new TopBarController();
  List<NotificacionModel> listanotificaciones = new List();
  AppLifecycleState notification;
  int cantidadNotificaciones;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      notification = state;
    });
  }

  @override
  void initState() {
    super.initState();
    cantidadNotificaciones = 0;
    gestionNotificaciones();
  }

  void gestionNotificaciones() async {
    Stream<List<NotificacionModel>> notificacionesStream =
        await topBarController.esucharnotificaciones();
    notificacionesStream.map((notificationesstream) {
      notificationesstream.forEach((element) {
        listanotificaciones.add(element);
      });
    });
/*     setState(() {
      if (listanotificaciones.length == 0) {
        cantidadNotificaciones = 0;
        print(cantidadNotificaciones);
      } else {
        cantidadNotificaciones = listanotificaciones.length;
        print(cantidadNotificaciones);
      }
    }); */
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget myAppBarIcon() {
      return Container(
        width: 30,
        height: 30,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            cantidadNotificaciones < 100
                ? Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffc32c37),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            "$cantidadNotificaciones",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 5),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffc32c37),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            "$cantidadNotificaciones",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    return AppBar(
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: myAppBarIcon(),
            onPressed: () {},
          )
        ],
        title: Text(widget.text,
            style: TextStyle(
                fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal)));
  }
}
