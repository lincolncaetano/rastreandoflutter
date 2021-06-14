import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Views/Home/DetalheEncomenda.dart';
import 'package:rastreando/Views/Home/EncomendaCadastro.dart';
import 'package:rastreando/Views/Home/Home.dart';
import 'package:rastreando/Views/Login/CadastroUsuario.dart';
import 'package:rastreando/Views/Login/Login.dart';
import 'package:rastreando/Views/Login/PreLogin.dart';
import 'package:rastreando/Views/Login/RecuperarSenha.dart';
import 'package:rastreando/Views/Tabs/Tabs.dart';
import 'package:rastreando/Views/Usuario/EditarPerfil.dart';

class Routers{

  static const String preLogin = '/preLogin';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String recuperarSenha = '/recuperarSenha';
  static const String home = '/home';
  static const String tabs = '/tabs';
  static const String editarPerfil = '/editarPerfil';
  static const String encomendaCadastro = '/encomendaCadastro';
  static const String encomendaDetalhe = '/encomendaDetalhe';


  static Route<dynamic> genarateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch( settings.name){
      case "/":
        return MaterialPageRoute(
            builder: (_) => PreLogin()
        );
      case preLogin:
        return MaterialPageRoute(
            builder: (_) => PreLogin()
        );
      case login:
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case cadastro:
        return MaterialPageRoute(
            builder: (_) => CadastroUsuario()
        );
      case recuperarSenha:
        return MaterialPageRoute(
          builder: (_) => RecuperaSenha()
      );
      case editarPerfil:
        return MaterialPageRoute(
            builder: (_) => EditarPerfil()
        );
      case tabs:
        return MaterialPageRoute(
            builder: (_) => Tabs()
        );
      case home:
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case encomendaCadastro:
        return MaterialPageRoute(
            builder: (_) => EncomendaCadastro()
        );
      case encomendaDetalhe:
        return MaterialPageRoute(
            builder: (_) => DetalheEncomenda(args)
        );

      default:
        _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela não encontrada"),
            ),
            body: Center(
              child: Text("Tela não encontrada"),
            ),
          );
        }
    );
  }
}