import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
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
  AdmobBannerSize bannerSize;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
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

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
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



                      return indice % 2 == 0 ? Container(
                        child: Column(
                          children: [
                            ItemEncomenda(
                                encomenda: encomenda
                            ),
                            AdmobBanner(
                              adUnitId: getBannerAdUnitId(),
                              adSize: AdmobBannerSize.BANNER,
                            )
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
    );
  }
}
