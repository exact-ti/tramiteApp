import 'package:flutter/material.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/Widgets/CardWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemTimeLineWidget.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class TrackingModal extends StatefulWidget {
  final int paqueteId;
  const TrackingModal({Key key, @required this.paqueteId}) : super(key: key);
  @override
  _TrackingModalState createState() => new _TrackingModalState();
}

class _TrackingModalState extends State<TrackingModal> {
  final NavigationService _navigationService = locator<NavigationService>();
  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());
  TrackingModel trackingModel = new TrackingModel();
  List<TrackingDetalleModel> detalles;

  @override
  void initState() {
    generateData(); 
    super.initState();
  }

  void generateData() async {
    this.trackingModel = await trackingCore.mostrarTracking(widget.paqueteId);
    this.detalles = this.trackingModel.detalles;
    if (this.mounted) {
      setState(() {
        this.trackingModel = this.trackingModel;
        this.detalles.sort((a, b) => a.fecha.compareTo(b.fecha));
      });
    }
  }

  String obtenerTextoCargo(dynamic detalleCargo) {
    String textCargo = "";
    if (detalleCargo == null) return null;
    switch (detalleCargo.tipoCargoModel.id) {
      case 1:
        textCargo = "Recibido con código ${detalleCargo.valor}";
        break;
      case 2:
        textCargo = "Cargo";
        break;
      default:
        textCargo = "Cargo";
    }
    return textCargo;
  }

  IconData obtenerIcono(dynamic detalleCargo) {
    IconData iconoCargo;
    if (detalleCargo == null) return null;
    switch (detalleCargo.tipoCargoModel.id) {
      case 1:
        iconoCargo = IconsData.ICON_CARD;
        break;
      case 2:
        iconoCargo = IconsData.ICON_FIRM;
        break;
      default:
        iconoCargo = IconsData.ICON_FIRM;
    }
    return iconoCargo;
  }

  TextStyle obtenerStyleCargo(dynamic detalleCargo) {
    TextStyle textStyleCargo;
    if (detalleCargo == null) return null;
    switch (detalleCargo.tipoCargoModel.id) {
      case 1:
        textStyleCargo = TextStyle(fontSize: 12);
        break;
      case 2:
        textStyleCargo = TextStyle(
            color: Colors.blue,
            fontSize: 12,
            decoration: TextDecoration.underline);
        break;
      default:
        textStyleCargo = TextStyle(fontSize: 12);
    }
    return textStyleCargo;
  }

  void onPressedrWidget(dynamic indiceWidget, dynamic trackingModel) {
    _navigationService.informacionCargo(
        "EXACT", trackingModel.detalles[indiceWidget].cargo, trackingModel);
  }

  dynamic converterMapTrackingModal(TrackingModel tracking) {
    return {
      "Código:": tracking.codigo,
      'De:':
          tracking.remitente == null ? 'Envío importado' : tracking.remitente,
      'Origen:': tracking.origen,
      'Para:': tracking.destinatario,
      'Destino:': tracking.destino,
      'Observación:': tracking.observacion
    };
  }

  @override
  Widget build(BuildContext context) {
    double heightCel = 0.6 * (MediaQuery.of(context).size.height);
    return AlertDialog(
        titlePadding: EdgeInsets.all(0),
        title: Container(
            alignment: Alignment.centerLeft,
            height: 60.00,
            width: double.infinity,
            child: Container(
                child: Text('EXACT', style: TextStyle(color: Colors.blue[200])),
                margin: const EdgeInsets.only(left: 20)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3.0, color: Colors.blue[200]),
              ),
            )),
        contentPadding: EdgeInsets.all(10),
        content: Container(
          height: heightCel,
          width: MediaQuery.of(context).size.width,
          child: this.detalles == null
              ? loadingGet()
              : Column(
                  children: <Widget>[
                    CardWidget(
                        colorCart: StylesThemeData.CARD_COLOR,
                        iconSuperior: IconsData.ICON_INFO,
                        infoMap: converterMapTrackingModal(this.trackingModel)),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                                itemCount: detalles.length,
                                itemBuilder: (context, i) => ItemTimeLineWidget(
                                      modal: trackingModel,
                                      actionWidget: onPressedrWidget,
                                      iconTitulo: IconsData.ICON_CALENDAR,
                                      iconSubtitulo: IconsData.ICON_USER,
                                      iconSubSecondtitulo: IconsData.ICON_SEDE,
                                      iconSubThirdtitulo:
                                          obtenerIcono(detalles[i].cargo),
                                      itemIndice: i,
                                      titulo: detalles[i].fecha,
                                      subtitulo: detalles[i].estado,
                                      subSecondtitulo: detalles[i].ubicacion,
                                      subThirdtitulo:
                                          obtenerTextoCargo(detalles[i].cargo),
                                      styleSubThirdtitulo:
                                          obtenerStyleCargo(detalles[i].cargo),
                                    )))),
                  ],
                ),
        ));
  }
}
