import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rastreando/Models/Encomenda.dart';

import '../../Routers.dart';

class ItemEncomenda extends StatelessWidget {

  final Encomenda encomenda;

  const ItemEncomenda({
    Key key,
    @required this.encomenda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, Routers.encomendaDetalhe, arguments: encomenda);
      },
      child: Container(
        //height: 50,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(DateFormat("dd/MM/yy").format(DateTime.parse(this.encomenda.eventos[0].dtHrCriado)),
                      style: TextStyle( fontSize: 12),),
                    Text(DateFormat("HH:mm").format(DateTime.parse(this.encomenda.eventos[0].dtHrCriado)),
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
                    Text(this.encomenda.descricao, style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold
                    ),),
                    Text(this.encomenda.eventos[0].descricao)
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Center(
                  child: Icon(Icons.arrow_forward_ios, size: 15,),
                ))
          ],
        ),
      ),
    );
  }
}
