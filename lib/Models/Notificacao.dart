import 'package:cloud_firestore/cloud_firestore.dart';

class Notificacao{

  String id;
  String texto;
  String idUsuarioDestinario;
  String idUsuarioRemetente;
  String tipo;
  String urlImage;
  FieldValue data;
  Timestamp dataTime;

  Notificacao(this.texto, this.idUsuarioDestinario, this.idUsuarioRemetente,{this.urlImage});

  Notificacao.novo(this.texto, this.idUsuarioDestinario, this.idUsuarioRemetente){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference denuncias = db.collection("denuncias");
    this.id = denuncias.doc().id;
  }

  Notificacao.fromDocSnap(DocumentSnapshot snapshot){
    this.id = snapshot.data()["id"];
    this.texto = snapshot.data()["texto"];
    this.idUsuarioDestinario = snapshot.data()["idUsuarioDestinario"];
    this.idUsuarioRemetente = snapshot.data()["idUsuarioRemetente"];
    this.tipo = snapshot.data()["tipo"];
    this.urlImage = snapshot.data()["urlImage"];
    this.dataTime = snapshot.data()["data"];
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "texto" : this.texto,
      "idUsuarioDestinario" : this.idUsuarioDestinario,
      "idUsuarioRemetente" : this.idUsuarioRemetente,
      "tipo" : this.tipo,
      "urlImage" : this.urlImage,
      "data" : this.data,
    };

    return map;
  }
}