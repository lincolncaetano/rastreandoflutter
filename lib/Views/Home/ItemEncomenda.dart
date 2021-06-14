import 'package:flutter/material.dart';
import 'package:rastreando/Models/Encomenda.dart';

class ItemEncomenda extends StatefulWidget {

  final Encomenda encomenda;

  const ItemEncomenda({
    Key key,
    @required this.encomenda
  }) : super(key: key);

  @override
  _ItemEncomendaState createState() => _ItemEncomendaState();
}

class _ItemEncomendaState extends State<ItemEncomenda> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Text(this.widget.encomenda.codObjeto),
    );
  }
}
