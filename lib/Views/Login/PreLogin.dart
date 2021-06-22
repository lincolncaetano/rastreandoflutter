import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Utils/FireUtils.dart';

class PreLogin extends StatefulWidget {
  @override
  _PreLoginState createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _verificaUsuarioLogado();
  }

  Future<void> _verificaUsuarioLogado() async {
    await FireUtils.verificaUsuarioLogado(context).then((value){
      user = value;
    });

    if(user != null){

      DocumentSnapshot snapshot = await db.collection("usuarios").doc(user.uid).get();
      Usuario usuario = Usuario.fromDocSnap(snapshot);

      Navigator.pushReplacementNamed(context, Routers.tabs);
    }
  }

/*  _verificaUsuarioLogado() async{
    //auth.signOut();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {

        Navigator.pushReplacementNamed(context, Routers.tabs);
      }
    });
  }*/

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset("images/logo.png", height: MediaQuery.of(context).size.width * 0.65),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              // fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                              color: Palleta.body2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(Palleta.getColor2)
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, Routers.login);
                          },
                        ),
                      ),
                    ],
                  )
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, Routers.cadastro);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child:  Center(
                  child: Text(
                    "Não tem conta? Cadastra-se",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
