import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:tramiteapp/src/Util/modals/confirmation.dart';
import 'package:tramiteapp/src/Util/modals/information.dart';
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:path/path.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tramiteapp/src/ModelDto/PaqueteExternoBuzonModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoController.dart';

class ImportarArchivoPage extends StatefulWidget {
  @override
  _ImportarArchivoPageState createState() => _ImportarArchivoPageState();

  final TipoPaqueteModel tipoPaqueteModel;

  const ImportarArchivoPage({Key key, this.tipoPaqueteModel}) : super(key: key);
}

class _ImportarArchivoPageState extends State<ImportarArchivoPage> {
  List<PaqueteExternoBuzonModel> data = new List<PaqueteExternoBuzonModel>();

  ImportarArchivoController imp = new ImportarArchivoController();

  String titulo = 'Importar envíos';

  @override
  Widget build(BuildContext context) {
    // const PrimaryColor = const Color(0xFF2C6983);
    // const LetraColor = const Color(0xFF68A1C8);

    return Scaffold(
      appBar: sd.crearTitulo(titulo),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _generarBotonAdjuntar(context),
            // Container(
            //   child: DataTable (

            //     columns: [
            //       DataColumn(label:Text('Código')),
            //       DataColumn(label:Text('Id-buzón')),
            //       DataColumn(label: Text('Buzón'))
            //     ],

            //     rows: <DataRow>[
            //         DataRow(
            //           cells:[
            //             DataCell(Text('prueba')),
            //             DataCell(Text('prueba')),
            //             DataCell(Text('prueba'))
            //           ]
            //         )
            //     ],
            //   )
            // ),
            Expanded(
                child: Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: (contenido == null ? Text('') : contenido)
                        // child: Column(
                        //   children: <Widget>[
                        //     mensajeResultado,
                        //     (contenido == null ? Text('') : contenido)
                        //   ]
                        // )
                        ))),
            contenido != null ? _generarBotonImportar(context) : Container()
          ],
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.file_upload),
      //       title : Text('Importar')
      //     )
      //   ],
      //   currentIndex: 0,
      // )
      // ,
      // floatingActionButton: FloatingActionButton.extended(

      //   onPressed: (){
      //     _importarRegistros(context);
      //     contenido = Container();

      //     setState(() {

      //     });
      //   },
      //   label: Text('Guardar'),
      //   icon: Icon(Icons.file_upload),
      //   backgroundColor: Colors.green,
      // ),
    );
  }

  final valorCampo = 'No encontrado';
  int totalFilas = 0;
  int codigosEncontrados = 0;
  int codigo_paquete_incorrecto = 0;
  var mensajeResultado = Text('');
  var contenido;
  final tituloVentana = "Importar envíos";

  Widget _generarBotonAdjuntar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
      child: Align(
        child: Container(
            alignment: Alignment.center,
            height: sd.screenHeightExcludingToolbar(context, dividedBy: 10),
            width: double.infinity,
            child: RaisedButton(
                padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
                textColor: Colors.white,
                color: sd.primaryColor,
                child: Text('Adjuntar', style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                onPressed: () {
                  contenido = _adjuntarArchivo(context);
                })),
      ),
    );
  }

  Widget _generarBotonImportar(BuildContext context) {
    this.codigo_paquete_incorrecto = 0;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
      child: Align(
        child: Container(
            alignment: Alignment.center,
            height: sd.screenHeightExcludingToolbar(context, dividedBy: 10),
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
              textColor: Colors.white,
              color: sd.primaryColor,
              child: Text('Importar', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {
                _importarRegistros(context);
                //contenido = Container();

                setState(() {});
              },
            )),
      ),
    );
  }

  void _importarRegistros(BuildContext context) async {
    List<PaqueteExterno> paqueteExternoList = new List<PaqueteExterno>();
    //validar
    if (this.data.length > 0) {
      for (var item in this.data) {
        if (item.nombre != 'No encontrado' &&
            item.id != null &&
            item.id.trim() != "") {
          PaqueteExterno paquete = new PaqueteExterno();
          paquete.paqueteId = item.id;
          paquete.destinatarioId = item.idBuzon.toString();
          paqueteExternoList.add(paquete);
        }
        if (item.id == null || item.id.trim() == "") {
          this.codigo_paquete_incorrecto++;
        }
      }

      if (this.data.length > paqueteExternoList.length) {
        var noencontrados = totalFilas - codigosEncontrados;

        var description = "";

        if (noencontrados > 1) {
          description = 'Existen ' +
              noencontrados.toString() +
              ' destinos no encontrados';
        } else {
          if (noencontrados == 1) {
            description =
                'Existe ' + noencontrados.toString() + ' destino no encontrado';
          }
        }

        if (this.codigo_paquete_incorrecto > 1) {
          description = description +
              ' y ' +
              this.codigo_paquete_incorrecto.toString() +
              ' códigos de paquete vacíos';
        } else {
          if (this.codigo_paquete_incorrecto == 1) {
            description = description +
                ' y ' +
                this.codigo_paquete_incorrecto.toString() +
                ' código de paquetes vacío';
          }
        }

        if (this.codigo_paquete_incorrecto > 0) {
          bool respuestabool = await confirmacion(context, "success", "EXACT", description);
          if(respuestabool!=null){
          if (!respuestabool) {
            return;
          }
          }
        }

        dynamic resp = await imp.importarPaquetesExternos(
            paqueteExternoList, widget.tipoPaqueteModel);

        if (resp["status"] == "success") {
          notificacion(context, "success", "EXACT", "Correcto");
          this.data = new List<PaqueteExternoBuzonModel>();
          this.totalFilas = 0;
          this.codigosEncontrados = 0;
          contenido = Container();
          setState(() {
            contenido = Container();
          });
        } else {
          List<dynamic> duplicados = resp["data"];
          confirmarNovalidados(context,"success", "EXACT",  resp["message"], duplicados);
        }
      } else {
        var descrip = "";

        if (this.codigo_paquete_incorrecto > 1) {
          descrip = 'Existen ' +
              this.codigo_paquete_incorrecto.toString() +
              ' códigos de paquete vacíos';
        } else {
          if (this.codigo_paquete_incorrecto == 1) {
            descrip = 'Existe ' +
                this.codigo_paquete_incorrecto.toString() +
                ' código de paquete vacío';
          }
        }
        if (this.codigo_paquete_incorrecto > 0) {
          bool respuestabool = await confirmacion(context, "success", "EXACT", descrip);
          if(respuestabool!=null){
          if (!respuestabool) {
            return;
          }
          }
        }

        dynamic resp = await imp.importarPaquetesExternos(
            paqueteExternoList, widget.tipoPaqueteModel);

        if (resp["status"] == "success") {
          notificacion(context, "success", "EXACT", "Correcto");
          this.data = new List<PaqueteExternoBuzonModel>();
          this.totalFilas = 0;
          this.codigosEncontrados = 0;
          this.codigo_paquete_incorrecto = 0;
          contenido = Container();
          setState(() {
            contenido = Container();
          });
        } else {
          List<dynamic> duplicados = resp["data"];
          confirmarNovalidados(context,"success", "EXACT",  resp["message"], duplicados);
        }
      }
    } else {
      notificacion(context, "error", "EXACT", 'No hay registros para exportar');
    }
  }

  void _mensajeAdvertenciaNoEncontrados(BuildContext context) {
    if (totalFilas > 0 && totalFilas > codigosEncontrados) {
      var mensaje = 'Existen ' +
          (totalFilas - codigosEncontrados).toString() +
          ' destinos no encontrados';
      TextStyle(color: Colors.red);
      notificacion(context, "error", "EXACT", mensaje);
    }
  }

  void _mensajeResultadoImportacion(BuildContext context) {
    var mensaje = '';
    TextStyle estilo;

    if (totalFilas == 0) {
      return;
    } else {
      if (totalFilas == codigosEncontrados) {
        mensaje = codigosEncontrados.toString() + ' correctos';
        estilo = new TextStyle(color: Colors.blue);
      } else {
        mensaje = 'Existen ' +
            (totalFilas - codigosEncontrados).toString() +
            ' destinos no encontrados';
        estilo = new TextStyle(color: Colors.red);
      }
    }
    notificacion(context, "error", "EXACT", mensaje);
    // return Text(
    //   mensaje,
    //   style: estilo,
    // );
  }

  Widget _adjuntarArchivo(BuildContext context) {
    return FutureBuilder(
        future: _generateListFromDecoderData(context),
        builder: (BuildContext context,
            AsyncSnapshot<List<PaqueteExternoBuzonModel>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Column(
              children: <Widget>[
                _createDataTableControl(context, snapshot.data)
              ],
            ));
          } else {
            return Container();
          }
        });
  }

  Future<File> _getFileFilterExtension(String fileExtension) async {
    File file = await FilePicker.getFile(
        type: FileType.CUSTOM, fileExtension: fileExtension);
    return file;
  }

  Future<SpreadsheetDecoder> getDecoderDataFromExcelFile() async {
    File file = await _getFileFilterExtension('xlsx');
    Uint8List bytes = file.readAsBytesSync();
    ByteData bytesData = ByteData.view(bytes.buffer);
    var decoder =
        new SpreadsheetDecoder.decodeBytes(bytesData.buffer.asUint8List());
    return decoder;
  }

  Future<List<PaqueteExternoBuzonModel>> _generateListFromDecoderData(
      BuildContext context) async {
    var decoder = await getDecoderDataFromExcelFile();
    String sheetName = widget.tipoPaqueteModel.nombre.toUpperCase();
    List<PaqueteExternoBuzonModel> paquetesBuzonValidar =
        new List<PaqueteExternoBuzonModel>();

    bool existeHoja = false;

    for (var key in decoder.tables.keys) {
      if (key.toString().toUpperCase() == sheetName) {
        existeHoja = true;
        break;
      }
    }

    if (!existeHoja) {
      notificacion(context, "error", "EXACT",
          "No existe una hoja con el nombre '$sheetName' en el archivo seleccionado");
      this.data = paquetesBuzonValidar;
      return paquetesBuzonValidar;
    }

    var tabla = decoder.tables['$sheetName'];
    int fila = 0;

    for (var row in tabla.rows) {
      if (fila > 0) {
        PaqueteExternoBuzonModel paqueteBuzon = new PaqueteExternoBuzonModel();
        paqueteBuzon.id = row[0] == null ? '' : row[0].toString();
        paqueteBuzon.idBuzon = row[1] == null ? '' : row[1].toString();
        paqueteBuzon.nombre = '';
        paquetesBuzonValidar.add(paqueteBuzon);
      }
      fila++;
    }

    this.data = paquetesBuzonValidar;
    return await _validarRegistroBuzones(paquetesBuzonValidar);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  List<PaqueteExternoBuzonModel> listaNoValidos =
      new List<PaqueteExternoBuzonModel>();

  Future<List<PaqueteExternoBuzonModel>> _validarRegistroBuzones(
      List<PaqueteExternoBuzonModel> lista) async {
    int encontrados = 0;
    int total = 0;
    total = lista.length;
    //Controller validar

    List<int> ids = new List<int>();

    for (PaqueteExternoBuzonModel item in lista) {
      if (!isNumeric(item.idBuzon)) {
        continue;
      }

      if (!ids.contains(item.idBuzon)) {
        ids.add(int.tryParse(item.idBuzon));
      }
    }

    List<BuzonModel> buzonModelList = await imp.listarBuzonesPorIds(ids);
    //
    for (PaqueteExternoBuzonModel item in lista) {
      item.nombre = valorCampo;
      item.estado = false;
      for (var buzon in buzonModelList) {
        if (int.tryParse(item.idBuzon) == buzon.id) {
          item.nombre = buzon.nombre;
          item.estado = true;
          encontrados++;
          break;
        }
      }
    }

    setState(() {
      totalFilas = total;
      codigosEncontrados = encontrados;
    });

    // mensajeResultado = _mensajeResultadoImportacion();

    return lista;
  }

  List<PaqueteExternoBuzonModel> listarCorrectosPrimeros(
      List<PaqueteExternoBuzonModel> data) {
    List<PaqueteExternoBuzonModel> listavacio = new List();
    int correctos = 0;
    for (PaqueteExternoBuzonModel paquete in data) {
      if (paquete.id == null || paquete.id == "") {
        paquete.estado = false;
      }
      if (paquete.estado) {
        if (correctos < 10) {
          listavacio.add(paquete);
          correctos++;
        }
      } else {
        listavacio.add(paquete);
      }
    }

    return listavacio;
  }

  Widget _createDataTableControl(
      BuildContext context, List<PaqueteExternoBuzonModel> data) {
    var widgets;
    List<PaqueteExternoBuzonModel> datashow = listarCorrectosPrimeros(data);
    if (data.length > 0) {
      widgets = datashow.map((item) {
        Color c = Colors.black;
        if (item.nombre == valorCampo) {
          c = Colors.red;
        }
        return DataRow(cells: [
          DataCell(Text(item.id.toString())),
          DataCell(Text(item.idBuzon.toString())),
          DataCell(Text(item.nombre, style: TextStyle(color: c)))
        ]);
      }).toList();
    } else {
      return Container();
    }

    return DataTable(
      headingRowHeight: 50.0, //horizontalMargin: 2.0,
      columns: [
        DataColumn(label: Text('Código')),
        DataColumn(label: Text('Id-buzón')),
        DataColumn(label: Text('Buzón'))
      ],
      rows: widgets,
    );
  }

  void confirmarNovalidados(
      BuildContext context,String tipo, String titulo, String descripcion, List<dynamic> novalidados) {
    List<Widget> listadecodigos = new List();

    for (dynamic codigo in novalidados) {
      listadecodigos.add(Text('$codigo'));
    }

    showDialog(
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
                      style: TextStyle(
                          color: tipo == "success"
                              ? Colors.blue[200]
                              : Colors.red[200])),
                  margin: const EdgeInsets.only(left: 20)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 3.0,
                      color: tipo == "success"
                          ? Colors.blue[200]
                          : Colors.red[200]),
                ),
              )),
            content:  SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: Column(children: <Widget>[
                  Container(
                      child: Text(descripcion),
                      margin: const EdgeInsets.only(bottom: 10)),
                  ListBody(children: listadecodigos)
                ]),
                padding: const EdgeInsets.all(20),
              ),
              InkWell(
                  onTap: () => Navigator.pop(context, true),
                  child: Center(
                      child: Container(
                          height: 50.00,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 3.0, color: Colors.grey[100]),
                                right: BorderSide(
                                    width: 1.5, color: Colors.grey[100])),
                          ),
                          child: Container(
                            child: Text('Volver a adjuntar archivo',
                                style: TextStyle(color: Colors.black)),
                          ))),
                )
            ]),
          ),
          contentPadding: EdgeInsets.all(0),
          );
        });
  }
}
