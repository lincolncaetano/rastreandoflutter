import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Models/Encomenda.dart';

import 'ItemEncomenda.dart';

class EncomendasEntregues extends StatefulWidget {
  @override
  _EncomendasEntreguesState createState() => _EncomendasEntreguesState();
}

class _EncomendasEntreguesState extends State<EncomendasEntregues> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _streamController = StreamController<QuerySnapshot>.broadcast();
  User user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _adicionarListenerEntregues();

  }

  _adicionarListenerEntregues() async{
    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection('usuarios')
        .doc(user.uid)
        .collection('encomendaEntregues')
        .snapshots();

    stream.listen((dados) {
      _streamController.add(dados);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entregues"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.pushNamed(context, Routers.encomendaCadastro);
          })
        ],),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (contex, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              break;
            case ConnectionState.active:
            case ConnectionState.done:

              if(snapshot.hasError){
                return Expanded(
                  child: Text("Erro ao carregar mensagens"),
                );
              }else{
                QuerySnapshot querySnapshot = snapshot.data;


                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (_, indice){
                      List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                      DocumentSnapshot documentSnapshot = anuncios[indice];
                      Encomenda encomenda = Encomenda.fromDocSnap(documentSnapshot);
                      return ItemEncomenda(
                          encomenda: encomenda
                      );
                    });

              }
          }
          return Container();
        },
      ),
    );
  }
}
