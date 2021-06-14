import 'package:cloud_firestore/cloud_firestore.dart';

class Endereco{

  String cidade;
  String uf;
  String nome;
  String tipo;

  Endereco();

  Endereco.fromDocSnap(DocumentSnapshot snapshot){
    this.cidade = snapshot.data()["cidade"];
    this.uf = snapshot.data()["uf"];
  }

  Endereco.fromJson(dynamic json){
    this.cidade = json["cidade"];
    this.uf = json["uf"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "cidade" : this.cidade,
      "uf" : this.uf,
    };

    return map;
  }
}