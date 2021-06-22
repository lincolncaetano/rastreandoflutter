import 'package:flutter/material.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Routers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key key}) : super(key: key);

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações", style: TextStyle(color:  Colors.white),),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, Routers.editarPerfil);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text("Editar Perfil", style: TextStyle(color: Palleta.body2),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Text("Sair", style: TextStyle(color: Palleta.body2),),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
