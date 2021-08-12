import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Views/Widgets/TextFormFieldCutom.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  User user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Usuario usuario;

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerDataNasc = TextEditingController();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    doSomeAsyncStuff();
  }

  Future<void> doSomeAsyncStuff() async {
    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });

    DocumentSnapshot snapshot = await db.collection("usuarios").doc(user.uid).get();
    setState(() {
      usuario = Usuario.fromDocSnap(snapshot);
      _controllerNome.text = usuario.nome;
      _controllerEmail.text = usuario.email;
      //_controllerCpf.text = usuario.cpf;
      //_controllerCelular.text = usuario.celular;
      //_controllerDataNasc.text = usuario.dataNascimento;
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNome.dispose();
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil", style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings_rounded), onPressed: (){
              Navigator.pushNamed(context, Routers.configuracoes).then((value) => doSomeAsyncStuff());
            })
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: usuario != null ?
                  CircleAvatar(
                      maxRadius: MediaQuery.of(context).size.width / 6 ,
                      backgroundColor: Colors.grey,
                      //backgroundImage: NetworkImage(usuario.foto)
                  ): CircleAvatar(
                    maxRadius: MediaQuery.of(context).size.width / 6 ,
                    backgroundColor: Colors.grey,
                  ),
                ),
                TextFormFieldCustom(
                  controller: _controllerNome,
                  label: "Nome",
                  enabled: false,
                ),
                TextFormFieldCustom(
                  controller: _controllerEmail,
                  label: "Email",
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
