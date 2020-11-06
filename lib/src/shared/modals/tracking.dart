import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/TrackingDetalle.dart';
import 'package:tramiteapp/src/ModelDto/TrackingModel.dart';
import 'package:tramiteapp/src/Providers/trackingProvider/impl/TrackingProvider.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingImpl.dart';
import 'package:tramiteapp/src/CoreProyecto/tracking/TrackingInterface.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/CardWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemTimeLineWidget.dart';
import 'package:tramiteapp/src/shared/modals/trackingCargo.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

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

TextStyle obtenerStyleCargo(dynamic detalleCargo) {
  TextStyle textStyleCargo;
  if (detalleCargo == null) return null;
  switch (detalleCargo.tipoCargoModel.id) {
    case 1:
      textStyleCargo = TextStyle(fontSize: 15);
      break;
    case 2:
      textStyleCargo = TextStyle(
          color: Colors.blue,
          fontSize: 15,
          decoration: TextDecoration.underline);
      break;
    default:
      textStyleCargo = TextStyle(fontSize: 15);
  }
  return textStyleCargo;
}

void onPressedrWidget(dynamic indiceWidget, dynamic trackingModel) {
  informacionCargo(
      "EXACT", trackingModel.detalles[indiceWidget].cargo, trackingModel);
}

void trackingPopUp(BuildContext context, int codigo) async {
  TrackingInterface trackingCore = new TrackingImpl(new TrackingProvider());
  double heightCel = 0.6 * (MediaQuery.of(context).size.height);
  TrackingModel trackingModel = await trackingCore.mostrarTracking(codigo);
  List<TrackingDetalleModel> detalles = trackingModel.detalles;
  detalles.sort((a, b) => a.fecha.compareTo(b.fecha));
  var detailTracking = {
    "Código:": trackingModel.codigo,
    'De:': trackingModel.remitente == null
        ? 'Envío importado'
        : trackingModel.remitente,
    'Origen:': trackingModel.origen,
    'Para:': trackingModel.destinatario,
    'Destino:': trackingModel.destino,
    'Observación:': trackingModel.observacion
  };
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
                alignment: Alignment.centerLeft,
                height: 60.00,
                width: double.infinity,
                child: Container(
                    child: Text('EXACT',
                        style: TextStyle(color: Colors.blue[200])),
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
              child: Column(
                children: <Widget>[
                  CardWidget(
                      colorCart: StylesThemeData.CARD_COLOR,
                      iconSuperior: IconsData.ICON_INFO,
                      infoMap: detailTracking),
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
                                    iconSubThirdtitulo: IconsData.ICON_CARD,
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
      });
}
