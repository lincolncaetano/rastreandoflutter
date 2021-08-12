import 'package:cloud_firestore/cloud_firestore.dart';

import 'Unidade.dart';

class Evento{

  String codigo;
  String descricao;
  String dtHrCriado;
  String tipo;
  Unidade unidade;

  Evento();

  Evento.fromDocSnap(DocumentSnapshot snapshot){
    this.codigo = snapshot.data()["codigo"];
    this.descricao = snapshot.data()["descricao"];
    this.dtHrCriado = snapshot.data()["dtHrCriado"];
    this.tipo = snapshot.data()["tipo"];
    this.unidade = snapshot.data()["unidade"];
  }

  Evento.fromJson(dynamic json){
    this.codigo = json["codigo"];
    this.descricao = json["descricao"];
    this.dtHrCriado = json["dtHrCriado"];
    this.tipo = json["tipo"];
    this.unidade = Unidade.fromJson(json["unidade"]);
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "codigo" : this.codigo,
      "descricao" : this.descricao,
      "dtHrCriado" : this.dtHrCriado,
      "tipo" : this.tipo,
      "unidade" : this.unidade.toMap(),
    };

    return map;
  }
}