import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Views/Home/EncomendasEntregues.dart';
import 'package:rastreando/Views/Home/Home.dart';
import 'package:rastreando/Views/Usuario/Perfil.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _indice = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _configToken();
  }

  _configToken() async{
    FirebaseMessaging  messaging = FirebaseMessaging.instance;
    String token = await messaging.getToken();
    await _salvandoToken(token);
    messaging.onTokenRefresh.listen(_salvandoToken);
  }

  _salvandoToken(String token) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'token': token
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> telas =[
      Home(),
      EncomendasEntregues(),
      Perfil()
    ];

    return Scaffold(
      body: telas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Palleta.tabs2,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 0,
        currentIndex: _indice,
        onTap: (index){
          setState(() {
            _indice = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            //title: Text("Home", style: TextStyle( fontSize: 8)),
              label: "Pendentes",
              icon: Icon(Icons.home, size: 0,)
          ),
          BottomNavigationBarItem(
            //title: Text("Home", style: TextStyle( fontSize: 8)),
              label: "Entregues",
              icon: Icon(Icons.home, size: 0,)
          ),
          BottomNavigationBarItem(
            //title: Text("Home", style: TextStyle( fontSize: 8)),
              label: "Perfil",
              icon: Icon(Icons.home, size: 0,)
          ),
        ],
      ),
    );

  }
}
