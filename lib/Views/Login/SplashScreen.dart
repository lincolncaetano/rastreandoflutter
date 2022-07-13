import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Utils/FireUtils.dart';

import '../../Routers.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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

      Future.delayed(Duration(seconds: 2)).then((value) => {
        Navigator.pushReplacementNamed(context, Routers.tabs)
      });

    }else{
      Future.delayed(Duration(seconds: 2)).then((value) => {
        Navigator.pushReplacementNamed(context, Routers.preLogin)
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palleta.body2,
      child: Center(
        child: Image.asset("assets/images/caixa.png", height: MediaQuery.of(context).size.width * 0.65),
      ),
    );
  }
}
