import 'package:cloud_firestore/cloud_firestore.dart';

class TipoPostal{

  String categoria;
  String descricao;
  String sigla;

  TipoPostal();

  TipoPostal.fromDocSnap(DocumentSnapshot snapshot){
    this.categoria = snapshot.data()["categoria"];
    this.descricao = snapshot.data()["descricao"];
    this.sigla = snapshot.data()["sigla"];
  }

  TipoPostal.fromJson(dynamic json){
    this.categoria = json["categoria"];
    this.descricao = json["descricao"];
    this.sigla = json["sigla"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "categoria" : this.categoria,
      "descricao" : this.descricao,
      "sigla" : this.sigla
    };

    return map;
  }
}