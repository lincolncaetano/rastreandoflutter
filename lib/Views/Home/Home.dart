import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Views/Home/ItemEncomenda.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _streamController = StreamController<QuerySnapshot>.broadcast();
  User user;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _adicionarListenerPendentes();
  }

  _adicionarListenerPendentes() async{
    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection('usuarios')
        .doc(user.uid)
        .collection('encomendaPendentes')
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
      appBar: AppBar(title: Text("Pendentes"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.pushNamed(context, Routers.encomendaCadastro);
          })
        ],),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: StreamBuilder(
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
                            return indice % 1 == 0 ? Container(
                              child: Column(
                                children: [
                                  ItemEncomenda(
                                      encomenda: encomenda
                                  ),

                                ],
                              ),
                            ) : ItemEncomenda(
                                encomenda: encomenda
                            ) ;
                          });

                    }
                }
                return Container();
              },
            ),
          ),
          Expanded(
            flex: 1,
              child: AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
          ))
        ],
      ),
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-4896657111169099/9028984969';
    }
    return null;
  }
}
