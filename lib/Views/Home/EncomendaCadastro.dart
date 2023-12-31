import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Encomenda.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Views/Widgets/TextFormFieldCutom.dart';
import 'package:http/http.dart' as http;
import 'package:validadores/validadores.dart';

import '../../Models/Encomenda.dart';

class EncomendaCadastro extends StatefulWidget {

  final Encomenda encomenda;
  EncomendaCadastro(this.encomenda);

  @override
  _EncomendaCadastroState createState() => _EncomendaCadastroState();
}

class _EncomendaCadastroState extends State<EncomendaCadastro> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final GlobalKey<ScaffoldMessengerState> scaffoldState = GlobalKey<ScaffoldMessengerState>();
  TextEditingController _controllerCodigo = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  Encomenda _encomenda;
  User user;
  AdmobReward rewardAd;
  bool alteracao = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _encomenda = new Encomenda();
    init();

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );
    rewardAd.load();
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      //return 'ca-app-pub-4896657111169099/3882914856';
    } else if (Platform.isAndroid) {
      print("android");
      return 'ca-app-pub-4896657111169099/5472883336';
    }
    return null;
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        salvarEncomenda();
        break;
      default:
    }
  }

  init() async {
    if(this.widget.encomenda != null){
      _encomenda = this.widget.encomenda;
      alteracao = true;
      _controllerCodigo.text = _encomenda.codObjeto;
      _controllerDescricao.text = _encomenda.descricao;
    }

    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    rewardAd.dispose();
  }


  buscarEncomenda() async{

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

      Map<String, dynamic> json = jsonDecode(response.body)["objetos"][0];

      if(json["mensagem"] == "SRO-019: Objeto inválido"){

        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Codigo inválido'),
                    ],
                  ),
                ),
                onWillPop: () async {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  return true;
                }
            );
          },
        );

      }
      else if(json["mensagem"] == "SRO-020: Objeto não encontrado na base de dados dos Correios."){

        Encomenda e = Encomenda();
        e.descricao = _controllerDescricao.text;
        e.idUsuario = user.uid;
        e.codObjeto = _controllerCodigo.text;
        _encomenda = e;

        rewardAd.show();

        /*
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Objeto não encontrado na base de dados dos Correios'),
                    ],
                  ),
                ),
                onWillPop: () async {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  return true;
                }
            );
          },
        );*/

      }
      else{
        print(json["mensagem"]);

        Encomenda e = Encomenda.fromJson(jsonDecode(response.body));
        e.descricao = _controllerDescricao.text;
        e.idUsuario = user.uid;
        _encomenda = e;

        rewardAd.show();
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  salvarEncomenda() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    if(_encomenda.eventos != null && _encomenda.eventos.length > 0 && _encomenda.eventos[0].codigo == "BDE"){
      db.collection("usuarios")
          .doc(user.uid)
          .collection("encomendaEntregues")
          .doc(_encomenda.codObjeto)
          .set(_encomenda.toMap());
    }else{
      db.collection("usuarios")
          .doc(user.uid)
          .collection("encomendaPendentes")
          .doc(_encomenda.codObjeto)
          .set(_encomenda.toMap());

      db.collection("encomendaPendentes")
          .doc(_encomenda.codObjeto)
          .set(_encomenda.toMap());
    }

    if(alteracao){
      Navigator.of(context).popUntil((route) => route.isFirst);
    }else{
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            child: Text("Salvar", style: TextStyle(color: Colors.white),),
            onPressed: (){
              buscarEncomenda();
            },
          )
        ]),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric( horizontal: 10),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
                child: Text("Adicionar encomenda" , style: TextStyle(color: Palleta.body2, fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              TextFormFieldCustom(
                controller: _controllerCodigo,
                label: "Codigo",
                type: TextInputType.text,
                enabled: !alteracao,
                textStyle: TextStyle(color: Palleta.body2),
                decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.fromLTRB(16, 8, 16, 8),
                    //hintText: "E-mail",
                    labelText: "Codigo",
                    //filled: true,
                    labelStyle: TextStyle(color: Palleta.body2),
                    disabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Palleta.body2 ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Palleta.body2 ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Palleta.body2 )
                    )),
                onSaved: (codigo){
                  _encomenda.codObjeto = codigo;
                },
                validator: (valor){
                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                      .valido(valor);
                },),
              TextFormFieldCustom(
                controller: _controllerDescricao,
                label: "Descricao",
                type: TextInputType.text,
                textStyle: TextStyle(color: Palleta.body2),
                decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.fromLTRB(16, 8, 16, 8),
                    //hintText: "E-mail",
                    labelText: "Descrição",
                    //filled: true,
                    labelStyle: TextStyle(color: Palleta.body2),
                    disabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Palleta.body2 ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide:  BorderSide(color: Palleta.body2 ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Palleta.body2 )
                    )),
                onSaved: (descricao){
                  _encomenda.descricao = descricao;
                },
                validator: (valor){
                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                      .valido(valor);
                },),
            ],
          ),
        ),
      ),
    );
  }
}
