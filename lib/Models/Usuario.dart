import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

  String idUsuario;
  String nome;
  String email;
  String senha;
  String cpf;
  String token;

  Usuario();

  Usuario.fromDocSnap(DocumentSnapshot snapshot){
    this.idUsuario = snapshot.id;
    this.nome = snapshot.data()["nome"];
    this.email = snapshot.data()["email"];
    this.cpf = snapshot.data()["cpf"];
    this.token = snapshot.data()["token"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "token" : this.token,
      "cpf" : this.cpf,
    };

    return map;
  }
}