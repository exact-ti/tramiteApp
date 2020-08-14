import 'TipoCargoModel.dart';

class CargoModel {
  int id;
  String valor;
  TipoCargoModel tipoCargoModel;

  CargoModel fromOneJsonCargo(dynamic json) {
    CargoModel cargoModel = new CargoModel();
    TipoCargoModel tipoCargoModel = new TipoCargoModel();
    if (json != null) {
      cargoModel.id = json["id"];
      cargoModel.valor = json["valor"];
      Map<String, dynamic> tipoCargoJson = json["tipoCargo"];
      tipoCargoModel.id = tipoCargoJson["id"];
      tipoCargoModel.nombre = tipoCargoJson['nombre'];
      tipoCargoModel.activo = tipoCargoJson['activo'];
      cargoModel.tipoCargoModel = tipoCargoModel;
    }else{
      cargoModel=null;
    }
    return cargoModel;
  }
}
