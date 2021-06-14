import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rastreando/Models/Evento.dart';

class ItemEvento extends StatelessWidget {
  final Evento evento;

  const ItemEvento({
    @required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 50,
      color: Colors.white,
      margin: EdgeInsets.only(top: 1),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text(DateFormat("dd/MM/yy").format(DateTime.parse(this.evento.dtHrCriado)),
                    style: TextStyle( fontSize: 12),),
                  Text(DateFormat("HH:mm").format(DateTime.parse(this.evento.dtHrCriado)),
                      style: TextStyle( fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.evento.descricao, style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold
                  ),),
                  Text(this.evento.unidade.nome, style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Icon(Icons.arrow_forward_ios, size: 12,),
              ))
        ],
      ),
    );
  }
}
