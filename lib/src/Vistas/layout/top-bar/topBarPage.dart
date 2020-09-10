import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Util/widgets/menuPopUp.dart';
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
  List<NotificacionModel> listanotificacionesPendientes = new List();
  AppLifecycleState notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      notification = state;
    });
  }

  @override
  void initState() {
    listanotificacionesPendientes = [];
    super.initState();
    /* gestionNotificaciones(); */
  }

  void gestionNotificaciones() async {
    listanotificacionesPendientes =
        await topBarController.listarNotificacionesPendientes();
    setState(() {
      listanotificacionesPendientes = listanotificacionesPendientes;
    });
    Stream<List<NotificacionModel>> notificacionesStream =
        topBarController.esucharnotificaciones3();
    notificacionesStream.listen((event) {
      listanotificacionesPendientes = event;
    });
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
            listanotificacionesPendientes.length < 100
                ? listanotificacionesPendientes.length!=0? Container(
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
                            listanotificacionesPendientes.length.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ) : Container()
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
                            listanotificacionesPendientes.length.toString(),
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
            onPressed: () {
              
            },
          ),
        ],
        title: Text(widget.text,
            style: TextStyle(
                fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal)));
  }
}
