import 'package:flutter/material.dart';

import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Views/Home/ItemEvento.dart';

class DetalheEncomenda extends StatefulWidget {

  final Encomenda encomenda;
  DetalheEncomenda(this.encomenda);

  @override
  _DetalheEncomendaState createState() => _DetalheEncomendaState();
}

class _DetalheEncomendaState extends State<DetalheEncomenda> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.widget.encomenda.codObjeto),),
      body: ListView.builder(
          itemCount: this.widget.encomenda.eventos.length,
          itemBuilder: (BuildContext context, int index){
            return ItemEvento(evento: this.widget.encomenda.eventos[index]);
          }
      ),
    );
  }
}
