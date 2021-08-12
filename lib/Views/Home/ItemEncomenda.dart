import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Palleta.dart';

import '../../Routers.dart';

class ItemEncomenda extends StatelessWidget {

  final Encomenda encomenda;
  final bool alerta;

  const ItemEncomenda({
    Key key,
    @required this.encomenda,
    this.alerta
  }) : super(key: key);


  Color getColorTexto(){
    if(alerta){
      return Palleta.vermelho;
    }else{
      return Colors.black;
    }
  }

  Color getColorData(){
    if(alerta){
      return Palleta.vermelho;
    }else{
      return Palleta.body2;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, Routers.encomendaDetalhe, arguments: encomenda);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: this.encomenda.eventos.length == 0 ? Container() : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Text(DateFormat("dd").format(DateTime.parse(this.encomenda.eventos[0].dtHrCriado)),
                        style: TextStyle( fontSize: 20, color: getColorData()),),
                      Text(DateFormat("MMMM", 'pt_Br').format(DateTime.parse(this.encomenda.eventos[0].dtHrCriado)),
                        style: TextStyle( fontSize: 16, color: getColorData()),),
                      Text(DateFormat("HH:mm").format(DateTime.parse(this.encomenda.eventos[0].dtHrCriado)),
                          style: TextStyle( fontSize: 8, color: getColorData())),
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
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: getColorTexto()
                      ),),
                      this.encomenda.eventos.length == 0 ? Text("Item não postado") : Text(this.encomenda.eventos[0].descricao, style: TextStyle(color: getColorTexto()),)
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios, size: 15, color: getColorTexto(),),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
