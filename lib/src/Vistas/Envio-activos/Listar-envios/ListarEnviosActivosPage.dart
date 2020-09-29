import 'package:flutter_tags/flutter_tags.dart';
import 'package:tramiteapp/src/ModelDto/EnvioModel.dart';
import 'package:tramiteapp/src/ModelDto/EstadoEnvio.dart';
import 'package:tramiteapp/src/Util/utils.dart';
import 'package:flutter/material.dart';
import 'package:tramiteapp/src/Vistas/Generar-envio/Crear-envio/EnvioController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'ListarEnviosActivosController.dart';
import 'package:tramiteapp/src/Util/modals/tracking.dart';

class ListarEnviosActivosPage extends StatefulWidget {
  final dynamic objetoModo;
  const ListarEnviosActivosPage({Key key, this.objetoModo}) : super(key: key);

  @override
  _ListarEnviosActivosPageState createState() =>
      _ListarEnviosActivosPageState(objetoModo);
}

class _ListarEnviosActivosPageState extends State<ListarEnviosActivosPage> {
  dynamic objetoModo;
  _ListarEnviosActivosPageState(this.objetoModo);
  EnviosActivosController principalcontroller = new EnviosActivosController();
  EnvioController envioController = new EnvioController();
  List<EstadoEnvio> estadosSave = new List();
  List<EnvioModel> envios = new List();
  List<int> estadosIds = new List();
  var listadestinatarios;
  String textdestinatario = "";
  List<bool> isSelected;
  int indexSwitch = 0;
  int numvalijas = 0;
  var listadetinatario;
  var listadetinatarioDisplay;
  var colorletra = const Color(0xFFACADAD);
  var prueba;
  String codigo = "";
  var nuevo = 0;

  @override
  void initState() {
    isSelected = [true, false];

    if (objetoModo == null) {
      estadosIds = [];
      isSelected = [true, false];
      indexSwitch = 0;
    } else {
      estadosIds.add(objetoModo["estadoid"]);
      if (objetoModo["modalidad"] == 1) {
        isSelected = [false, true];
        indexSwitch = 1;
      } else {
        isSelected = [true, false];
        indexSwitch = 0;
      }
    }
    setState(() {
      textdestinatario = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItem(EnvioModel entrega, int switched) {
      String codigopaquete = entrega.codigoPaquete;
      String destinatario = entrega.destinatario;
      String observacion = entrega.observacion;
      String fecha = entrega.fecha;
      return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          decoration: myBoxDecoration(colorletra),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("$destinatario"),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("$fecha")))
                ],
              ))),
              Expanded(
                  child: Container(
                      child: Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Text("$codigopaquete",
                            style: TextStyle(color: Colors.blue)),
                        onTap: () {
                          trackingPopUp(context, entrega.id);
                        },
                      )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("$observacion")))
                ],
              )))
            ],
          ));
    }

    Widget listTagSave(List<int> idsparam) {
      List<EstadoEnvio> listaparam = new List();
      estadosSave.forEach((element) {
        if (element.estado) {
          listaparam.add(element);
        }
      });
      return Container(
          child: Tags(
        itemCount: listaparam.length,
        itemBuilder: (int index) {
          return Tooltip(
              message: listaparam[index].nombre,
              child: ItemTags(
                title: listaparam[index].nombre,
                pressEnabled: false,
                textStyle: TextStyle(fontSize: 13),
                key: Key(index.toString()),
                index: index,
              ));
        },
      ));
    }

    Widget listTagFuture(List<int> estadosParam) {
      return FutureBuilder(
          future: principalcontroller.listarEnviosEstados(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EstadoEnvio>> snapshot) {
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
                    estadosSave = snapshot.data;
                    if (estadosSave.length != 0) {
                      List<EstadoEnvio> listaparam = new List();
                      if (objetoModo != null) {
                        estadosSave.forEach((element) {
                          if (element.id == objetoModo["estadoid"]) {
                            listaparam.add(element);
                            element.estado = true;
                          } else {
                            element.estado = false;
                          }
                        });
                      } else {
                        estadosSave.forEach((element) {
                          listaparam.add(element);
                          element.estado = true;
                        });
                      }

                      return Container(
                          child: Tags(
                        itemCount: listaparam.length,
                        itemBuilder: (int index) {
                          return Tooltip(
                              message: listaparam[index].nombre,
                              child: ItemTags(
                                title: listaparam[index].nombre,
                                pressEnabled: false,
                                textStyle: TextStyle(fontSize: 13),
                                key: Key(index.toString()),
                                index: index,
                              ));
                        },
                      ));
                    } else {
                      return Container();
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }

          });
    }

    Widget listarTags(
        List<EstadoEnvio> estadosparam, List<int> estadosidsparam) {
      if (estadosparam.length == 0) {
        return listTagFuture(estadosidsparam);
      } else {
        return listTagSave(estadosidsparam);
      }
    }

    Widget _crearListado(int switched) {
      envios.clear();
      return FutureBuilder(
          future:
              principalcontroller.listarActivosController(switched, estadosIds),
          builder:
              (BuildContext context, AsyncSnapshot<List<EnvioModel>> snapshot) {

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
                    final envios = snapshot.data;
                    if (envios.length == 0) {
                      return sinResultados("No se han encontrado resultados");
                    } else {
                      return ListView.builder(
                          itemCount: envios.length,
                          itemBuilder: (context, i) => crearItem(envios[i], switched));
                    }
                  } else {
                    return sinResultados("No se han encontrado resultados");
                  }
                }
            }
          });
    }

    Widget tabs = ToggleButtons(
      borderColor: colorletra,
      fillColor: colorletra,
      borderWidth: 1,
      selectedBorderColor: colorletra,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Enviados',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Por recibir',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
          indexSwitch = index;
        });
      },
      isSelected: isSelected,
    );

    Future<List<int>> popupEstados(
        BuildContext context, String titulo, List<int> idsestado) async {
      List<int> listarids = new List();
      if (idsestado.length == 0) {
        estadosSave.forEach((element) {
          element.estado = true;
        });
      } else {
        estadosSave.forEach((element) {
          if (idsestado.contains(element.id)) {
            element.estado = true;
          } else {
            element.estado = false;
          }
        });
      }
      bool respuesta = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                  alignment: Alignment.centerLeft,
                  height: 60.00,
                  width: double.infinity,
                  child: Container(
                      child: Text('$titulo',
                          style: TextStyle(color: Colors.blue[200])),
                      margin: const EdgeInsets.only(left: 20)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 3.0, color: Colors.blue[200]),
                    ),
                  )),
              content: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Container(
                          child: Text("Seleccionar estados"),
                          margin: const EdgeInsets.only(bottom: 10)),
                      ListBody(
                          children: estadosSave.map((estado) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return new CheckboxListTile(
                              title: new Text(estado.nombre),
                              value: estado.estado,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool value) {
                                setState(() {
                                  estado.estado = value;
                                });
                              });
                        });
                      }).toList())
                    ]),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () => estadosSave
                                      .where(
                                          (element) => element.estado == true)
                                      .length !=
                                  0
                              ? Navigator.pop(context, true)
                              : null,
                          child: Center(
                              child: Container(
                                  height: 50.00,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: 3.0,
                                            color: Colors.grey[100]),
                                        right: BorderSide(
                                            width: 1.5,
                                            color: Colors.grey[100])),
                                  ),
                                  child: Container(
                                    child: Text('Confirmar',
                                        style: TextStyle(color: Colors.black)),
                                  ))),
                        ),
                        flex: 5,
                      ),
                      Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () => Navigator.pop(context, false),
                            child: Center(
                                child: Container(
                                    height: 50.00,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 3.0,
                                              color: Colors.grey[100]),
                                          left: BorderSide(
                                              width: 1.5,
                                              color: Colors.grey[100])),
                                    ),
                                    child: Container(
                                      child: Text('Cancelar',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ))),
                          ))
                    ],
                  )
                ]),
              ),
              contentPadding: EdgeInsets.all(0),
            );
          });

      if (respuesta == null || !respuesta) {
        return idsestado;
      } else {
        estadosSave.forEach((element) {
          if (element.estado) {
            listarids.add(element.id);
          }
        });
        return listarids;
      }
    }

    Widget estadoButton = ButtonTheme(
      minWidth: 130.0,
      height: 40.0,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () async {
            estadosIds = await popupEstados(context, "EXACT", estadosIds);
            setState(() {
              estadosIds = estadosIds;
            });
          },
          color: Color(0xFF2C6983),
          child: Text('Estado', style: TextStyle(color: Colors.white))),
    );

    Widget mainscaffold() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.bottomLeft,
                  height: screenHeightExcludingToolbar(context, dividedBy: 10),
                  width: double.infinity,
                  child: estadoButton),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: listarTags(estadosSave, estadosIds)),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                height: screenHeightExcludingToolbar(context, dividedBy: 20),
                child: tabs),
            Expanded(
              child: Container(
                  decoration: myBoxDecoration(colorletra),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: _crearListado(indexSwitch)),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Envios activos",leadingbool: boolIfPerfil()?false:true,),
        drawer: drawerIfPerfil(),
        body: mainscaffold());
  }
}
