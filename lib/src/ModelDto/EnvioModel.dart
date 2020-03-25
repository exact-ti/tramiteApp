class EnvioModel {
  int remitenteId;
  int destinatarioId;
  String codigoPaquete;
  String codigoUbicacion;
  String observacion;


      EnvioModel({
        this.remitenteId,
        this.destinatarioId,
        this.codigoUbicacion='',
        this.codigoPaquete='',
        this.observacion='',
    });


         

    Map<String, dynamic> toJson() => {
        "remitenteId"         : remitenteId,
        "destinatarioId"     : destinatarioId,
        "codigoPaquete"   : codigoPaquete,
         "codigoUbicacion"     : codigoUbicacion,
        "observacion"   : observacion,       
    };

}