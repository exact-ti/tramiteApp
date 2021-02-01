import 'package:flutter/material.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:intl/intl.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/services/locator.dart';
import 'package:tramiteapp/src/services/navigation_service_file.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TapSectionListWidget.dart';
import 'package:tramiteapp/src/shared/modals/TrackingModal.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'package:tramiteapp/src/styles/Item_style.dart';
import 'package:tramiteapp/src/styles/Title_style.dart';
import 'HistoricoController.dart';

class HistoricoPage extends StatefulWidget {
  @override
  _HistoricoPageState createState() => new _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  TextEditingController _finController = TextEditingController();
  TextEditingController _inicioController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  List<EnvioModel> listaEnviosEntrada = new List();
  List<EnvioModel> listaEnviosSalida = new List();
  HistoricoController principalcontroller = new HistoricoController();
  FocusNode f1inicio = FocusNode();
  FocusNode f2fin = FocusNode();
  bool pressButton = false;
  void initState() {
    super.initState();
  }

  void onPressedCodeEntrada(dynamic indiceListEnvios) {
    showDialog(
        context: context,
        builder: (_) {
          return TrackingModal(
            paqueteId: listaEnviosEntrada[indiceListEnvios].id,
          );
        });
  }

  void onPressedCodeSalida(dynamic indiceListEnvios) {
    showDialog(
        context: context,
        builder: (_) {
          return TrackingModal(
            paqueteId: listaEnviosSalida[indiceListEnvios].id,
          );
        });
  }

  void listarEnvios() async {
    _navigationService.showModal();
    this.listaEnviosEntrada =
        await principalcontroller.listarHistoricosController(
            _inicioController.text, _finController.text, 0);

    this.listaEnviosSalida =
        await principalcontroller.listarHistoricosController(
            _inicioController.text, _finController.text, 1);
    if (mounted) {
      setState(() {
        this.listaEnviosEntrada = this.listaEnviosEntrada;
        this.listaEnviosSalida = this.listaEnviosSalida;
      });
    }

    this.pressButton = true;
    _navigationService.goBack();
  }

  pressConsulta() {
    if (_inicioController.text != "" && _finController.text != "") {
      DateTime finicio =
          new DateFormat("dd/MM/yyyy").parse(_inicioController.text);
      DateTime ffin = new DateFormat("dd/MM/yyyy").parse(_finController.text);
      var difference = ffin.difference(finicio).inDays;
      if (difference >= 0) {
        listarEnvios();
      } else {
        notificacion(context, "error", "EXACT",
            "La fecha inicial no debe ser mayor a la final");
        setState(() {
          this.pressButton = false;
        });
      }
    } else {
      notificacion(context, "error", "EXACT", "Se debe completar los datos");
      setState(() {
        this.pressButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var fechainicio = InkWell(
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
            helpText: "Seleccionar fecha",
            context: context,
            locale: const Locale("es", "ES"),
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            fieldLabelText: "Ingresar fecha",
            errorFormatText: "Formato inválido",
          );
          if (date != null) {
            DateTime fecha =
                new DateFormat("yyyy-MM-dd").parse(date.toIso8601String());
            String fechaString = DateFormat('yyyy-MM-dd').format(fecha);
            String dateFormate =
                DateFormat("dd-MM-yyyy").format(DateTime.parse(fechaString));
            _inicioController.text = dateFormate.replaceAll(RegExp('-'), '/');
          }
        },
        child: TextFormField(
          controller: _inicioController,
          obscureText: false,
          enabled: false,
          focusNode: f1inicio,
          cursorColor: StylesThemeData.PRIMARY_COLOR,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              suffixIcon: Icon(IconsData.ICON_CALENDAR),
              filled: true,
              fillColor: StylesThemeData.INPUT_COLOR,
              errorStyle: TextStyle(
                  color: StylesThemeData.INPUT_ERROR_COLOR, fontSize: 15.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: StylesThemeData.INPUT_ENFOQUE_COLOR),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: StylesThemeData.INPUT_ERROR_COLOR),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: StylesThemeData.INPUT_BORDER_COLOR,
                  width: 0.0,
                ),
              ),
              hintText: "Desde",
              hintStyle: TextStyle(color: StylesThemeData.INPUT_HINT_COLOR)),
        ));

    Widget fechafin = InkWell(
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
            helpText: "Seleccionar fecha",
            context: context,
            locale: const Locale("es", "ES"),
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            fieldLabelText: "Ingresar fecha",
            errorFormatText: "Formato inválido",
          );
          if (date != null) {
            DateTime fecha =
                new DateFormat("yyyy-MM-dd").parse(date.toIso8601String());
            String fechaString = DateFormat('yyyy-MM-dd').format(fecha);
            String dateFormate =
                DateFormat("dd-MM-yyyy").format(DateTime.parse(fechaString));
            _finController.text = dateFormate.replaceAll(RegExp('-'), '/');
          }
        },
        child: TextFormField(
          controller: _finController,
          obscureText: false,
          enabled: false,
          focusNode: f2fin,
          cursorColor: StylesThemeData.PRIMARY_COLOR,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              suffixIcon: Icon(IconsData.ICON_CALENDAR),
              filled: true,
              fillColor: StylesThemeData.INPUT_COLOR,
              errorStyle: TextStyle(
                  color: StylesThemeData.INPUT_ERROR_COLOR, fontSize: 15.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: StylesThemeData.INPUT_ENFOQUE_COLOR),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: StylesThemeData.INPUT_ERROR_COLOR),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: StylesThemeData.INPUT_BORDER_COLOR,
                  width: 0.0,
                ),
              ),
              hintText: "Hasta",
              hintStyle: TextStyle(color: StylesThemeData.INPUT_HINT_COLOR)),
        ));

    Widget itemEntradas(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listaEnviosEntrada[indice].remitente == null
              ? "De: Envío importado"
              : "De: ${listaEnviosEntrada[indice].remitente}",
          subtitulo: "Para ${listaEnviosEntrada[indice].destinatario}",
          subSecondtitulo: "${listaEnviosEntrada[indice].codigoPaquete}",
          subFivetitulo: "${listaEnviosEntrada[indice].observacion}",
          onPressedCode: onPressedCodeEntrada,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    Widget itemSalidas(dynamic indice) {
      return ItemWidget(
          itemHeight: StylesItemData.ITEM_HEIGHT_THREE_TITLE,
          itemIndice: indice,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: listaEnviosSalida[indice].remitente == null
              ? "De: Envío importado"
              : "De: ${listaEnviosSalida[indice].remitente}",
          subtitulo: "Para ${listaEnviosSalida[indice].destinatario}",
          subSecondtitulo: "${listaEnviosSalida[indice].codigoPaquete}",
          subFivetitulo: "${listaEnviosSalida[indice].observacion}",
          onPressedCode: onPressedCodeSalida,
          styleTitulo: StylesTitleData.STYLE_TITLE,
          styleSubTitulo: StylesTitleData.STYLE_SUBTILE,
          styleSubSecondtitulo: StylesTitleData.STYLE_SUBTILE_OnPressed,
          iconColor: StylesThemeData.ICON_COLOR);
    }

    Widget mainscaffold() {
      return Column(
        children: <Widget>[
          paddingWidget(Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: fechainicio),
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: fechafin),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ButtonWidget(
                      iconoButton: IconsData.ICON_SEARCH,
                      onPressed: pressConsulta,
                      colorParam: StylesThemeData.PRIMARY_COLOR,
                      texto: 'Buscar')),
            ],
          )),
          !pressButton
              ? Container()
              : Expanded(
                  child: Container(
                  child: TabSectionListWidget(
                    iconPrimerTap: IconsData.ICON_POR_RECIBIR,
                    iconSecondTap: IconsData.ICON_ENVIADOS,
                    namePrimerTap: "Entradas",
                    nameSecondTap: "Salidas",
                    listPrimerTap: listaEnviosEntrada,
                    listSecondTap: listaEnviosSalida,
                    itemPrimerTapWidget: itemEntradas,
                    itemSecondTapWidget: itemSalidas,
                    initstateIndex: 0,
                  ),
                  margin: const EdgeInsets.only(bottom: 5),
                )),
        ],
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          text: "Históricos",
          leadingbool: boolIfPerfil() ? false : true,
        ),
        drawer: drawerIfPerfil(),
        resizeToAvoidBottomInset: false,
        body: mainscaffold());
  }
}
