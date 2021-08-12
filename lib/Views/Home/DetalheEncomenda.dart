import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Views/Home/ItemEvento.dart';

import '../../Routers.dart';

class DetalheEncomenda extends StatefulWidget {

  final Encomenda encomenda;
  DetalheEncomenda(this.encomenda);

  @override
  _DetalheEncomendaState createState() => _DetalheEncomendaState();
}

class _DetalheEncomendaState extends State<DetalheEncomenda> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final GlobalKey<ScaffoldMessengerState> scaffoldState = GlobalKey<ScaffoldMessengerState>();
  User user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    init();
  }
  init() async {
    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void excluir(){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios")
        .doc(user.uid)
        .collection("encomendaPendentes")
        .doc(this.widget.encomenda.codObjeto)
        .delete();

    db.collection("encomendaPendentes")
        .doc(this.widget.encomenda.codObjeto)
        .delete();


    Navigator.of(context).popUntil((route) => route.isFirst);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text(this.widget.encomenda.descricao, style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
              child: Text("Editar", style: TextStyle(color:  Colors.white),),
              onPressed: (){

                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Editar'),
                            onTap: () {
                              Navigator.pushNamed(context, Routers.encomendaCadastro, arguments: this.widget.encomenda);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.delete),
                            title: new Text('Excluir'),
                            onTap: () {
                              excluir();
                            },
                          ),
                        ],
                      );
                    }
                );
              })
        ],),
      body: ListView.builder(
          itemCount: this.widget.encomenda.eventos.length,
          itemBuilder: (BuildContext context, int index){
            if(index == 0){
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(this.widget.encomenda.codObjeto, style: TextStyle(color: Colors.white),),
                ),
                ItemEvento(evento: this.widget.encomenda.eventos[index])
              ],);
            }
            return ItemEvento(evento: this.widget.encomenda.eventos[index]);
          }
      ),
    );
  }
}
