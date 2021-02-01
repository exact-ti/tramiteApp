import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tramiteapp/src/Entity/PaqueteExterno.dart';
import 'package:tramiteapp/src/ModelDto/BuzonModel.dart';
import 'package:tramiteapp/src/ModelDto/TipoPaqueteModel.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:tramiteapp/src/ModelDto/PaqueteExternoBuzonModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoController.dart';
import 'package:tramiteapp/src/Vistas/layout/App-bar/AppBarPage.dart';
import 'package:tramiteapp/src/Vistas/layout/Menu-Navigation/DrawerPage.dart';
import 'package:tramiteapp/src/shared/Widgets/ButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/FilaButtonWidget.dart';
import 'package:tramiteapp/src/shared/Widgets/TableWidget.dart';
import 'package:tramiteapp/src/shared/modals/confirmation.dart';
import 'package:tramiteapp/src/shared/modals/information.dart';
import 'package:tramiteapp/src/styles/Color_style.dart';

class ImportarArchivoPage extends StatefulWidget {
  @override
  _ImportarArchivoPageState createState() => _ImportarArchivoPageState();

  final TipoPaqueteModel tipoPaqueteModel;

  const ImportarArchivoPage({Key key, this.tipoPaqueteModel}) : super(key: key);
}

class _ImportarArchivoPageState extends State<ImportarArchivoPage> {
  List<PaqueteExternoBuzonModel> data = new List<PaqueteExternoBuzonModel>();
  ImportarArchivoController imp = new ImportarArchivoController();
  final valorCampoNoIngresado = 'No ingresado';
  final valorCampoIncorrecto = 'No encontrado';
  var dataTable;
  TipoPaqueteModel tipoPaquete;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => inicializarPaquete());
    super.initState();
  }

  void inicializarPaquete() {
    if (this.mounted) {
      Map paquete = ModalRoute.of(context).settings.arguments;
      if (paquete != null) {
        tipoPaquete = paquete['tipoPaquete'];
        setState(() {
          tipoPaquete = tipoPaquete;
        });
      }
    }
  }

  void _importarRegistros(BuildContext context) async {
    List<PaqueteExterno> paqueteExternoList = this
        .data
        .where((paquete) => paquete.estado)
        .map((paquete) => new PaqueteExterno(
            paqueteId: paquete.id.toString(),
            destinatarioId: paquete.idBuzon.toString()))
        .toList();

    bool contieneErrores = this
        .data
        .where((envioExterno) => !envioExterno.estado)
        .toList()
        .isNotEmpty;

    bool respuestaConfirmation = await confirmacion(
        context,
        contieneErrores ? "error" : "success",
        "EXACT",
        contieneErrores
            ? "Este archivo contiene errores. ¿Desea registrar los envíos correctos?"
            : "¿Desea registrar los envíos?");
    if (respuestaConfirmation) {
      dynamic resp =
          await imp.importarPaquetesExternos(paqueteExternoList, tipoPaquete);

      if (resp["status"] == "success") {
        notificacion(
            context, "success", "EXACT", "Se registraron los documentos");
        this.data = new List<PaqueteExternoBuzonModel>();
        dataTable = null;
        setState(() {
          dataTable = null;
        });
      } else {
        List<dynamic> duplicados = resp["data"];
        this.data.forEach((paquete) {
          if (duplicados.contains(paquete.id.toString())) {
            paquete.estado = false;
            paquete.id = paquete.id.toString() + "(R)";
            paquete.textIdPaquete = Text(
              paquete.id,
              style: TextStyle(color: Colors.red),
            );
          }
        });
        setState(() {
          this.data = this.data;
          this.dataTable = _createDataTableControl(context, this.data);
        });
      }
    }
  }

  Widget _createDataTableControl(
      BuildContext context, List<PaqueteExternoBuzonModel> data) {
    List<String> textHeader = ["Código", "Id. Buzón", "Buzón"];
    List<List<Widget>> listRow = new List();
    data.forEach((paqueteBuzon) {
      List<Widget> rowData = [
        paqueteBuzon.textIdPaquete,
        paqueteBuzon.textIdBuzon,
        paqueteBuzon.textNombreBuzon
      ];
      listRow.add(rowData);
    });
    return Container(
      child: TableWidget(
          colorHeader: StylesThemeData.PRIMARY_COLOR,
          listTitles: textHeader,
          listRow: listRow),
    );
  }

  void _adjuntarArchivo(BuildContext context) async {
    this.data = await generarListaPaqueteByExcel(context);
    if (this.data.isEmpty) {
      setState(() {
        this.dataTable = null;
        this.data = null;
      });
    } else {
      setState(() {
        this.dataTable = _createDataTableControl(context, this.data);
      });
    }
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<List<PaqueteExternoBuzonModel>> _validarRegistroBuzones(
      List<PaqueteExternoBuzonModel> lista) async {
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

    for (PaqueteExternoBuzonModel item in lista) {
      item.nombre =
          item.idBuzon == "" ? valorCampoNoIngresado : valorCampoIncorrecto;
      item.estado = false;
      item.textIdPaquete = Text(
        item.id == "" ? valorCampoNoIngresado : item.id,
        style: TextStyle(color: item.id == "" ? Colors.red : Colors.black),
      );
      item.textIdBuzon = Text(
        item.idBuzon,
        style: TextStyle(color: Colors.red),
      );
      item.textNombreBuzon = Text(
        item.nombre,
        style: TextStyle(color: Colors.red),
      );
      for (var buzon in buzonModelList) {
        if (int.tryParse(item.idBuzon) == buzon.id) {
          item.nombre = buzon.nombre;
          item.textIdBuzon = Text(
            item.idBuzon,
            style: TextStyle(color: Colors.black),
          );
          item.textNombreBuzon = Text(
            item.nombre,
            style: TextStyle(color: Colors.black),
          );
          item.estado = true;
          if (item.id == "") {
            item.estado = false;
          }
          break;
        }
      }
    }

    return lista;
  }

  Future<List<PaqueteExternoBuzonModel>> generarListaPaqueteByExcel(
      BuildContext context) async {
    var decoder = await getDecoderDataFromExcelFile();
    String sheetName = tipoPaquete.nombre.toUpperCase();
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
      return paquetesBuzonValidar;
    }

    var tabla = decoder.tables['$sheetName'];
    int fila = 0;

    for (var row in tabla.rows) {
      if (fila > 0) {
        PaqueteExternoBuzonModel paqueteBuzon = new PaqueteExternoBuzonModel();
        paqueteBuzon.id = row.first == null ? '' : row.first.toString();
        paqueteBuzon.idBuzon = row[1] == null ? '' : row[1].toString();
        paqueteBuzon.nombre = '';
        paquetesBuzonValidar.add(paqueteBuzon);
      }
      fila++;
    }

    List<String> listCodigos = new List();
    paquetesBuzonValidar.forEach((paquete) {
      if (!listCodigos.contains(paquete.id)) {
        listCodigos.add(paquete.id);
      }
    });

    if (listCodigos.length != paquetesBuzonValidar.length) {
      notificacion(context, "error", "EXACT",
          "No adjuntar el archivo con códigos repetidos");
      return [];
    }

    return await _validarRegistroBuzones(paquetesBuzonValidar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: 'Importar envíos'),
      drawer: DrawerPage(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                    child: FilaButtonWidget(
                        firsButton: ButtonWidget(
                            onPressed: () {
                              _adjuntarArchivo(context);
                            },
                            colorParam: StylesThemeData.BUTTON_PRIMARY_COLOR,
                            texto: "Adjuntar")))),
            Expanded(
                child: this.dataTable == null ? Container() : this.dataTable),
            dataTable != null
                ? Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ButtonWidget(
                        onPressed: () {
                          if (this
                              .data
                              .where((envio) => envio.estado)
                              .toList()
                              .isNotEmpty) {
                            _importarRegistros(context);
                          }
                        },
                        colorParam: this
                                .data
                                .where((envio) => envio.estado)
                                .toList()
                                .isNotEmpty
                            ? StylesThemeData.BUTTON_PRIMARY_COLOR
                            : StylesThemeData.BUTTON_DISABLE_COLOR,
                        texto: 'Importar'))
                : Container()
          ],
        ),
      ),
    );
  }
}
