import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Endereco.dart';

class Unidade{

  String codMcu;
  String codSro;
  String nome;
  String tipo;
  Endereco endereco;

  Unidade();

  Unidade.fromDocSnap(DocumentSnapshot snapshot){
    this.codMcu = snapshot.data()["codMcu"];
    this.codSro = snapshot.data()["codSro"];
    this.nome = snapshot.data()["nome"];
    this.tipo = snapshot.data()["tipo"];
    this.endereco = snapshot.data()["endereco"];
  }


  Unidade.fromJson(dynamic json){
    this.codMcu = json["codMcu"];
    this.codSro = json["codSro"];
    this.nome = json["nome"];
    this.tipo = json["tipo"];
    this.endereco = Endereco.fromJson(json["endereco"]);
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "codMcu" : this.codMcu,
      "codSro" : this.codSro,
      "nome" : this.nome,
      "tipo" : this.tipo,
      "endereco" : this.endereco.toMap(),
    };

    return map;
  }
}