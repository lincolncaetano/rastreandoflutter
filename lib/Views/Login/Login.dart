import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Palleta.dart';
import 'package:validadores/validadores.dart';

import '../../Routers.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _email;
  String _senha;


  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _verificaUsuarioLogado() async{
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
  }

  _loginUsuario(Usuario usuario) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usuario.email,
          password: usuario.senha
      );
      Navigator.pushNamedAndRemoveUntil(context, Routers.tabs, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Palleta.botao, //change your color here
        ),
        title: Text("Login" , style: TextStyle(color: Palleta.botao),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/logo.png", height: MediaQuery.of(context).size.width * 0.6),
                 *//* Text("Konsagrado",
                      style: TextStyle(
                        fontSize: 20 *
                            MediaQuery.of(context).textScaleFactor,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w300,
                      ))*//*
                ],
              ),*/
              Container(
                //height: MediaQuery.of(context).size.height * 0.45,
                  padding: EdgeInsets.all(20),
                  //color: Colors.yellow,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: _controllerEmail,
                            onSaved: (email){
                              _email= email.trim();
                            },
                            validator: (valor){
                              return Validador()
                                  .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                  .add(Validar.EMAIL, msg: "email inválido")
                                  .valido(valor);
                            },
                            style: TextStyle(
                              /* fontSize: 16 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,*/
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.fromLTRB(16, 8, 16, 8),
                                //hintText: "E-mail",
                                labelText: "E-mail",
                                //filled: true,
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(50))),
                          ),
                        ),
                        TextFormField(
                          autofocus: false,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          controller: _controllerSenha,
                          onSaved: (senha){
                            _senha = senha;
                          },
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .minLength(6, msg: "Minimo de 6 caracteres")
                                .valido(valor);
                          },
                          style: TextStyle(
                            /*fontSize: 16 *
                                        MediaQuery.of(context).textScaleFactor,*/
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              //hintText: "Senha",
                              labelText: "Senha",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(50))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: GestureDetector(
                              onTap: () => {
                                Navigator.pushNamed(context, Routers.recuperarSenha)
                              },
                              child: Text('esqueceu sua senha?',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 13,
                                    color: const Color(0xffffffff),
                                    //fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.right
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                color: Palleta.contrasteEscuro,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(Palleta.getColor)
                            ),
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                Usuario u = Usuario();
                                u.email = _email;
                                u.senha = _senha;

                                _loginUsuario(u);

                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
