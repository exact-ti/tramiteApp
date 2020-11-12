import 'package:tramiteapp/src/ModelDto/RecorridoModel.dart';
import 'package:tramiteapp/src/ModelDto/RutaModel.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/icons/theme_data.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ItemsWidget/ItemColumnWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/ListItemsWidget/FutureItemWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';
import 'GenerarRutaController.dart';

class GenerarRutaPage extends StatefulWidget {
  final RecorridoModel recorridopage;

  const GenerarRutaPage({Key key, this.recorridopage}) : super(key: key);

  @override
  _GenerarRutaPageState createState() => _GenerarRutaPageState(recorridopage);
}

class _GenerarRutaPageState extends State<GenerarRutaPage> {
  RecorridoModel recorridoUsuario;
  _GenerarRutaPageState(this.recorridoUsuario);
  GenerarRutaController principalcontroller = new GenerarRutaController();
  List<RutaModel> lisRutas = new List();
  int recorridoId;
  int indicePagina;
  @override
  void initState() {
       WidgetsBinding.instance
        .addPostFrameCallback((_) => inicializarParametros());
    super.initState();
  }

  void inicializarParametros() {
    if (mounted) {
      Map recorrido = ModalRoute.of(context).settings.arguments;
      setState(() {
        recorridoId = recorrido["recorridoId"];
        indicePagina = recorrido["indicepagina"];
      });
    }
  }

  void onPresBack() {
    Navigator.of(context).pop();
  }

  void actionButton() async {
    if (indicePagina != 1) {
      if (this.lisRutas.length != 0) {
        bool respuestabool = await confirmacion(
            context, "success", "EXACT", "Tienes pendientes ¿Desea Continuar?");
        if (respuestabool) {
          principalcontroller.opcionRecorrido(
              recorridoId, indicePagina, context);
        }
      } else {
        principalcontroller.opcionRecorrido(recorridoId, indicePagina, context);
      }
    } else {
      principalcontroller.opcionRecorrido(recorridoId, indicePagina, context);
    }
  }

  void setList(List<dynamic> listDynamic) {
    this.lisRutas = listDynamic;
  }

  @override
  Widget build(BuildContext context) {
    void onPressedRuta(dynamic indiceRutas) {
      RutaModel ruta = this.lisRutas[indiceRutas];

      Navigator.of(context).pushNamed(
        '/detalleruta',
        arguments: {
          'ruta': ruta,
          'recorridoId': this.recorridoId,
        },
      );
/*       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleRutaPage(objetoModo: objetoSend),
          )); */
    }

    Widget itemRuta(dynamic indice) {
      return ItemColumnWidget(
          itemHeight: 80.0,
          iconPrimary: IconsData.ICON_LOCATION,
          itemIndice: indice,
          methodAction: onPressedRuta,
          colorItem: indice % 2 == 0
              ? StylesThemeData.ITEM_SHADED_COLOR
              : StylesThemeData.ITEM_UNSHADED_COLOR,
          titulo: lisRutas[indice].nombre,
          secondTitulo: "Para recoger",
          thirdTitulo: "Para entrega",
          subThirdtitulo: "${lisRutas[indice].cantidadEntrega}",
          subSecondTitulo: "${lisRutas[indice].cantidadRecojo}");
    }

    Widget filaBotones = Container(
        child: FilaButtonWidget(
      firsButton: ButtonWidget(
          iconoButton:
              indicePagina == 1 ? IconsData.ICON_STAR : IconsData.ICON_BACK,
          onPressed: onPresBack,
          colorParam: StylesThemeData.BUTTON_SECUNDARY_COLOR,
          texto: indicePagina == 1 ? "Empezar recorrido" : "Retroceder"),
      secondButton: ButtonWidget(
          iconoButton:
              indicePagina == 1 ? IconsData.ICON_STAR : IconsData.ICON_FINISH,
          onPressed: actionButton,
          colorParam: StylesThemeData.PRIMARY_COLOR,
          texto: indicePagina == 1 ? 'Empezar recorrido' : 'Terminar'),
    ));

    return Scaffold(
        appBar: CustomAppBar(text: "Consultas"),
        drawer: DrawerPage(),
        body: scaffoldbody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                paddingWidget(Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    width: double.infinity,
                    child: Text("Tu ruta",
                        style: TextStyle(
                            fontSize: 20,
                            color: StylesThemeData.LETTER_COLOR)))),
                FutureItemWidget(
                    itemWidget: itemRuta,
                    setList: setList,
                    futureList: principalcontroller.listarMiRuta(recorridoId)),
                paddingWidget(Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    width: double.infinity,
                    child: indicePagina != 1
                        ? filaBotones
                        : ButtonWidget(
                            iconoButton: indicePagina == 1
                                ? IconsData.ICON_STAR
                                : IconsData.ICON_FINISH,
                            onPressed: actionButton,
                            colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                            texto: indicePagina == 1
                                ? 'Empezar recorrido'
                                : 'Terminar'))),
              ],
            ),
            context));
  }
}
