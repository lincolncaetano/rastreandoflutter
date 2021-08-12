import 'dart:async';
import 'dart:convert';

import 'package:rastreando/Models/Notificacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rastreando/Models/Usuario.dart';


class FireUtils {

  static Future<User> verificaUsuarioLogado(BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuario = auth.currentUser;
    if(usuario == null){
      //Navigator.pushReplacementNamed(context, Routers.preLogin);
    }else{
      return usuario;
    }
  }

  static preparaNotificao(String idDestinatario, String idRemetente, String msg, {String urlImage}) async {

    FirebaseFirestore _db = FirebaseFirestore.instance;

    Notificacao notificacao = Notificacao.novo(
        msg,
        idDestinatario,
        idRemetente
    );

    notificacao.data = FieldValue.serverTimestamp();

    if(urlImage != null){
      notificacao.urlImage = urlImage;
    }

    print(idDestinatario);

    DocumentSnapshot ds = await _db.collection("usuarios").doc(idDestinatario).get();
    Usuario usuario = Usuario.fromDocSnap(ds);

    if(urlImage != null){
      //sendAndRetrieveMessage(usuario.token, usuario.nome +" "+ msg, url: urlImage);
    }else{
      //sendAndRetrieveMessage(usuario.token, usuario.nome +" "+ msg);
    }
  }

  static sendAndRetrieveMessage(String token,String msg,{String url, String titulo}) async {

    final String serverToken = 'AAAAUDmRn2M:APA91bEp9B4OYUcoCeGqTBT4Q8pMUU2frI1GiMrJvXG1lEvvcEUC5kPs0djl6H3x8biVUX6-xDCCgEWWu17R8_J2i50jnCFxksDTr9pV4JvXpKWReXg5Hl7PZfJzNRy3LVKVBMaO5TuI';

    String title;
    if(titulo == null){
      title ='Konsagrado Barbearia';
    }else{
      title = titulo;
    }

    Uri uri = Uri.https("fcm.googleapis.com", "/fcm/send");

    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': msg,
            'title': title,
            "image": url
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
  }

}