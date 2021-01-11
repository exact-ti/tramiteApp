import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tramiteapp/src/Enumerator/EstadoAppOpenEnum.dart';
import 'package:tramiteapp/src/Enumerator/EstadoNotificacionEnum.dart';
import 'package:tramiteapp/src/ModelDto/NotificacionModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/Notificaciones/NotificacionesPage.dart';
import 'package:tramiteapp/src/Vistas/SettingsView/SettingsPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/services/notificationProvider.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'AppBarController.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  final bool leadingbool;
  @override
  final Size preferredSize;
  CustomAppBar({
    @required this.text,
    this.leadingbool,
  }) : preferredSize = Size.fromHeight(56.0);

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppBarState();
  }
}

class _CustomAppBarState extends State<CustomAppBar>
    with WidgetsBindingObserver {
  AppBarController appBarController = new AppBarController();
  List<NotificacionModel> listanotificacionesSinVer = new List();
  final NavigationService _navigationService = locator<NavigationService>();
  int estadoApp;
  int idBuzonOrUTD = 0;
  final _prefs = new PreferenciasUsuario();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index != EstadoAppOpenEnum.APP_INACTIVO) {
      Provider.of<NotificationInfo>(context, listen: false).estadoApp = state.index;
      if (state.index == EstadoAppOpenEnum.APP_RESUMED) {
        _prefs.estadoAppOpen = true;        
        appBarController.cancelarNotificacionPushByBuzon();
      }
      if(state.index == EstadoAppOpenEnum.APP_BACKGROUND){
        _prefs.estadoAppOpen = false;
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => listarNotificacionesPendientes());
    listanotificacionesSinVer = [];
    estadoApp = 0;
    registrarIfPerfil();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void listarNotificacionesPendientes() async {
    List<NotificacionModel> listanotificacionesPendientes = await appBarController.listarNotificacionesPendientes();
    Provider.of<NotificationInfo>(context, listen: false).cantidadNotificacion =
        listanotificacionesPendientes
            .where((element) =>
                element.notificacionEstadoModel.id ==
                EstadoNotificacionEnum.NOTIFICACION_PENDIENTE)
            .toList()
            .length; 
  }

  void registrarIfPerfil() {
    if (boolIfPerfil()) {
      idBuzonOrUTD = obtenerBuzonid();
    } else {
      idBuzonOrUTD = obtenerUTDid();
    }
  }

  void dirigirHome() {
    gestionNotificaciones();
    if (boolIfPerfil()) {
      if (idBuzonOrUTD != obtenerBuzonid()) {
        navegarHomeExact(context);
      }
    } else {
      if (idBuzonOrUTD != obtenerUTDid()) {
        navegarHomeExact(context);
      }
    }
  }

  void gestionNotificaciones() async {
    List<NotificacionModel> listanotificacionesPendientes =
        await appBarController.listarNotificacionesPendientes();

    if (this.mounted) {
      setState(() {
        listanotificacionesSinVer = listanotificacionesPendientes
            .where((element) => element.notificacionEstadoModel.id == EstadoNotificacionEnum.NOTIFICACION_PENDIENTE)
            .toList();
        Provider.of<NotificationInfo>(context, listen: false)
            .cantidadNotificacion = listanotificacionesSinVer.length;
                        print("listanotificacionesSinVer"+listanotificacionesSinVer.length.toString());

      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
              IconsData.ICON_NOTIFICATIONS,
              color: Colors.white,
              size: 30,
            ),
            Provider.of<NotificationInfo>(context).cantidadNotificacion < 100
                ? Provider.of<NotificationInfo>(context).cantidadNotificacion !=
                        0
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
                                "${Provider.of<NotificationInfo>(context).cantidadNotificacion}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
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
                            "${Provider.of<NotificationInfo>(context).cantidadNotificacion}",
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
        backgroundColor: StylesThemeData.PRIMARY_COLOR,
        automaticallyImplyLeading:
            widget.leadingbool == null || widget.leadingbool == true
                ? true
                : false,
        actions: [
          IconButton(
            icon: Icon(IconsData.ICON_USERCICLE, size: 30),
            onPressed: () async {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: SettingPage(),
                ),
              ).whenComplete(dirigirHome);
            },
          ),
          IconButton(
            icon: myAppBarIcon(),
            onPressed: () async {
              _navigationService.setCantidadNotificacionBadge(0);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NotificacionesPage(),
                ),
              ).whenComplete(gestionNotificaciones);
            },
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
