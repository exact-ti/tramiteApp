class EnvioModel {
  int remitenteId;
  int destinatarioId;
  String codigoPaquete;
  String codigoBandeja;
  String observacion;


      EnvioModel({
        this.remitenteId,
        this.destinatarioId,
        this.codigoBandeja='',
        this.codigoPaquete='',
        this.observacion='',
    });


         

    Map<String, dynamic> toJson() => {
        "remitenteId"         : remitenteId,
        "destinatarioId"     : destinatarioId,
        "codigoPaquete"   : codigoPaquete,
         "codigoBandeja"     : codigoBandeja,
        "observacion"   : observacion,       
    };

}