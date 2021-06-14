import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Views/Widgets/TextFormFieldCutom.dart';
import 'package:http/http.dart' as http;

class EncomendaCadastro extends StatefulWidget {
  const EncomendaCadastro({Key key}) : super(key: key);

  @override
  _EncomendaCadastroState createState() => _EncomendaCadastroState();
}

class _EncomendaCadastroState extends State<EncomendaCadastro> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController _controllerCodigo = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  Encomenda _encomenda;
  User user;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _encomenda = new Encomenda();
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


  salvarEncomenda() async{


    Uri uri = Uri.parse("https://proxyapp.correios.com.br/v1/sro-rastro/"+_controllerCodigo.text);

    //final response = await http.get(Uri.parse("proxyapp.correios.com.br/v1/sro-rastro/"+_encomenda.codObjeto));
    final response = await http.get(
      uri = uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Encomenda e = Encomenda.fromJson(jsonDecode(response.body));
      e.descricao = _controllerDescricao.text;
      e.idUsuario = user.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;


      if(e.eventos.length > 0 && e.eventos[0].codigo == "BDE"){
        db.collection("usuarios")
            .doc(user.uid)
            .collection("encomendaEntregues")
            .doc(e.codObjeto)
            .set(e.toMap());
      }else{
        db.collection("usuarios")
            .doc(user.uid)
            .collection("encomendaPendentes")
            .doc(e.codObjeto)
            .set(e.toMap());

        db.collection("encomendaPendentes")
            .doc(e.codObjeto)
            .set(e.toMap());
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar encomenda"),
        actions: <Widget>[
          TextButton(
            child: Text("Salvar"),
            onPressed: (){
              salvarEncomenda();
            },
          )
        ]),
      body: Column(
        children: [
          TextFormFieldCustom(
            controller: _controllerCodigo,
            label: "Codigo",
            type: TextInputType.text,
            onSaved: (codigo){
              _encomenda.codObjeto = codigo;
            },
            validator: (valor){},),
          TextFormFieldCustom(
            controller: _controllerDescricao,
            label: "Descricao",
            type: TextInputType.text,
            onSaved: (descricao){
              _encomenda.descricao = descricao;
            },
            validator: (valor){},),
        ],
      ),
    );
  }
}
