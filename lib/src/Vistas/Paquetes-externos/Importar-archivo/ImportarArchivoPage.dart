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
import 'package:tramiteapp/src/Util/utils.dart' as sd;
import 'package:path/path.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tramiteapp/src/ModelDto/PaqueteExternoBuzonModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tramiteapp/src/Vistas/Paquetes-externos/Importar-archivo/ImportarArchivoController.dart';


class ImportarArchivoPage extends StatefulWidget {

  @override
  _ImportarArchivoPageState createState() =>  _ImportarArchivoPageState();
  
  final TipoPaqueteModel tipoPaqueteModel;

  const ImportarArchivoPage ({Key key, this.tipoPaqueteModel}) : super(key:key);

}

class _ImportarArchivoPageState extends State<ImportarArchivoPage>{

  
  List<PaqueteExternoBuzonModel> data = new List<PaqueteExternoBuzonModel>();
  
  ImportarArchivoController imp = new ImportarArchivoController();
  
  @override
  Widget build(BuildContext context) {
    
    const PrimaryColor = const Color(0xFF2C6983);
    const LetraColor = const Color(0xFF68A1C8); 

    Size screenSize(BuildContext context) {
      return MediaQuery.of(context).size;
    }

    double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
      return (screenSize(context).height - reducedBy) / dividedBy;
    }

    double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
      return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Custodia de documentos externos',
              style: TextStyle(
                        fontSize: 18,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal))
      ),
      drawer: sd.crearMenu(context),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,          
          
          children: <Widget>[

            Container(
              padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 0),
              child: Align(                
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child: FlatButton.icon(
                      padding: const EdgeInsets.all(15.0),                      
                      textColor: Colors.white,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        
                        contenido = _adjuntarArchivo(context);


                        // setState(() {

                        //   // mensajeResultado = _mensajeResultadoImportacion();
                        // });
                        
                        // _mensajeResultadoImportacion(context);

                      },
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                      label: Text('Adjuntar',
                        style: TextStyle(
                          fontSize: 16,
                        )
                      ),
                      
                    )),
              ),
            ),

            SafeArea(
              child:
              SingleChildScrollView(
                child: Column(
                                
                  children: <Widget>[
                    mensajeResultado, 
                    (contenido == null ? Text('') : contenido)
                  ]

                )
              )
            )
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        
        onPressed: (){
          _importarRegistros(context);
          contenido = Container();          

          setState(() {
            
          });
        },
        label: Text('Guardar'),
        icon: Icon(Icons.file_upload),
        backgroundColor: Colors.green,
      ),
    );


    


  }

  final valorCampo = 'No encontrado';
  int totalFilas = 0;
  int codigosEncontrados = 0;
  var mensajeResultado = Text('');  
  var contenido;

  void _importarRegistros(BuildContext context) async {

    List<PaqueteExterno> paqueteExternoList = new List<PaqueteExterno>();
    //validar
    if (this.data.length > 0){

      for (var item in this.data) {
        if (item.nombre != 'No encontrado'){
          PaqueteExterno paquete = new PaqueteExterno();
          paquete.paqueteId = item.id;
          paquete.destinatarioId = item.idBuzon.toString();
          paqueteExternoList.add(paquete);
        }
      }

      if (this.data.length > paqueteExternoList.length){
        
        var description = 'Existen ' + (totalFilas - codigosEncontrados).toString() + ' destinos no encontrados';
      
        bool respuesta = await sd.confirmarRespuesta(context, 'Importar paquetes', description);

        if (!respuesta){
          return;
        }
        
        bool resp = await imp.importarPaquetesExternos(paqueteExternoList, widget.tipoPaqueteModel);

        if (resp){
          sd.mostrarAlerta(context, 'Correcto', 'Importar paquetes');
          this.data = new List<PaqueteExternoBuzonModel>();
          this.totalFilas = 0;
          this.codigosEncontrados = 0;
        }
        else{
          sd.mostrarAlerta(context, 'Error', 'Importar paquetes');
        }
      }
      else{
        bool resp = await imp.importarPaquetesExternos(paqueteExternoList, widget.tipoPaqueteModel);

        if (resp){
          sd.mostrarAlerta(context, 'Correcto', 'Importar paquetes');
          this.data = new List<PaqueteExternoBuzonModel>();
          this.totalFilas = 0;
          this.codigosEncontrados = 0;
        }
        else{
          sd.mostrarAlerta(context, 'Error', 'Importar paquetes');
        }
      }
      
    }
    else{
      sd.mostrarAlerta(context, 'No hay registros para exportar', 'Importar paquetes');
    }

  }

  void _mensajeAdvertenciaNoEncontrados(BuildContext context){
    if (totalFilas > 0 && totalFilas > codigosEncontrados){
      var mensaje = 'Existen ' + (totalFilas - codigosEncontrados).toString() + ' destinos no encontrados';
        TextStyle(
          color: Colors.red
        );
      sd.mostrarAlerta(context, mensaje, 'Importar paquetes');
    }
  }

  void _mensajeResultadoImportacion(BuildContext context){

    var mensaje = '';
    TextStyle estilo;
    

    // if (contenido == null)
    // {
    //   // return Text('');
    //   // sd.mostrarAlerta(context, mensaje, titulo)
    //   return;
    // }

    if (totalFilas == 0){
      return;
    }
    else {
      if (totalFilas == codigosEncontrados){
        mensaje = codigosEncontrados.toString() + ' correctos';
        estilo = new TextStyle(
          color: Colors.blue
        );
      }
      else {
        mensaje = 'Existen ' + (totalFilas - codigosEncontrados).toString() + ' destinos no encontrados';
        estilo = new TextStyle(
          color: Colors.red
        );
      }
    }
    sd.mostrarAlerta(context, mensaje, 'Importar archivo');
    // return Text(
    //   mensaje,
    //   style: estilo,
    // );
  }

  Widget _adjuntarArchivo(BuildContext context) {      

    return FutureBuilder(
      future: _generateListFromDecoderData(context),
      builder: (BuildContext context, AsyncSnapshot<List<PaqueteExternoBuzonModel>> snapshot){
        
        if (snapshot.hasData){
          return Container(
            child: Column(
              children: <Widget>[
                 _createDataTableControl(context,snapshot.data)
              ],
            )
          );
        }
        else{
          return Container();
        }
        
        
      }
    );

  }

  Future<File> _getFileFilterExtension(String fileExtension) async {
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: fileExtension);
    return file;
  }

  Future<SpreadsheetDecoder> getDecoderDataFromExcelFile() async {
    File file = await _getFileFilterExtension('xlsx');
    Uint8List bytes = file.readAsBytesSync();
    ByteData bytesData = ByteData.view(bytes.buffer);    
    var decoder = new SpreadsheetDecoder.decodeBytes(bytesData.buffer.asUint8List());
    return decoder;
  }

  Future<List<PaqueteExternoBuzonModel>> _generateListFromDecoderData(BuildContext context) async {
   
    var decoder = await getDecoderDataFromExcelFile();    
    String sheetName = widget.tipoPaqueteModel.nombre.toUpperCase();
    List<PaqueteExternoBuzonModel> paquetesBuzonValidar = new List<PaqueteExternoBuzonModel>();    
    
    bool existeHoja = false;

    for (var key in decoder.tables.keys) {
      if (key.toString().toUpperCase() == sheetName){
        existeHoja = true;
        break;
      }
    }

    if (!existeHoja){
      sd.mostrarAlerta(context, "No existe una hoja con el nombre '$sheetName' en el archivo seleccionado", "Importar archivo Excel");
      this.data = paquetesBuzonValidar;
      return paquetesBuzonValidar;
    }

    var tabla = decoder.tables['$sheetName'];    
    int fila = 0;

    for (var row in tabla.rows) {
      if (fila > 0){      
        PaqueteExternoBuzonModel paqueteBuzon = new PaqueteExternoBuzonModel();
        paqueteBuzon.id = row[0].toString();
        paqueteBuzon.idBuzon = row[1];
        paqueteBuzon.nombre = '';
        paquetesBuzonValidar.add(paqueteBuzon);  
      }   
      fila++;
    }
    
    this.data = paquetesBuzonValidar;
    return  await _validarRegistroBuzones(paquetesBuzonValidar);
  }  

  Future<List<PaqueteExternoBuzonModel>> _validarRegistroBuzones(List<PaqueteExternoBuzonModel> lista) async {

    int encontrados = 0;
    int total = 0;
    total = lista.length;
    //Controller validar

    List<int> ids = new List<int>();

    for (PaqueteExternoBuzonModel item in lista) {

      if(!ids.contains(item.idBuzon)){
        ids.add(item.idBuzon);
      }
    }
    
    List<BuzonModel> buzonModelList = await imp.listarBuzonesPorIds(ids);
    //
    for (PaqueteExternoBuzonModel item in lista) {
      
      item.nombre = valorCampo;

      for (var buzon in buzonModelList) {
        if (item.idBuzon == buzon.id){
          item.nombre = buzon.nombre;
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
  
  Widget _createDataTableControl(BuildContext context, List<PaqueteExternoBuzonModel> data)  {

    var widgets;  
   
    if (data.length > 0){

      widgets = data.map((item){

        Color c = Colors.black;

        if (item.nombre == valorCampo) {
          c = Colors.red;
        }

        return DataRow(
          cells:[
                DataCell(Text(item.id.toString())),
                DataCell(Text(item.idBuzon.toString())),
                DataCell(Text(item.nombre, style: TextStyle(color: c)))
              ]
        );

      }).toList();

    }
    else {      
      return Container();
    }

    return DataTable (
      columns: [
        DataColumn(label:Text('Código')),
        DataColumn(label:Text('Destino')),
        DataColumn(label: Text('Buzon'))
      ],
      rows: widgets,              
    );

      
    
  } 
  

}