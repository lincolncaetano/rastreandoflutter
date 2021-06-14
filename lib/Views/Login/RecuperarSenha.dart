import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreando/Palleta.dart';
import 'package:validadores/validadores.dart';

class RecuperaSenha extends StatefulWidget {
  @override
  _RecuperaSenhaState createState() => _RecuperaSenhaState();
}

class _RecuperaSenhaState extends State<RecuperaSenha> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static final _formKey = new GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  String _email;

  _recuperarSenha(String email){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: email)
        .then((value){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Novo link será enviado para seu email"),
          )
      );
    })
        .catchError((onError){
          print(onError);
      if(onError.toString().contains("user-not-found")){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Email não cadastrado!"),
            )
        );
      }
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar Senha"),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          child: Center(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Konsagrado Barbearia",
                            style: TextStyle(
                              fontSize: 20 *
                                  MediaQuery.of(context).textScaleFactor,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w300,
                            ))
                      ],
                    ),
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
                                  controller: _controllerEmail,
                                  onSaved: (email){
                                    _email= email.trim();
                                  },
                                  autofocus: false,
                                  keyboardType: TextInputType.emailAddress,
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
                                    fontWeight: FontWeight.w300,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding:
                                      EdgeInsets.fromLTRB(16, 8, 16, 8),
                                      hintText: "E-mail",
                                      filled: true,
                                      //fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(50))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith(Palleta.getColor)
                                  ),
                                  child: Text(
                                    "Recuperar Senha",
                                    style: TextStyle(
                                      // fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                                      color: Palleta.contrasteEscuro,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      _formKey.currentState.save();
                                      _recuperarSenha(_email);
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
          )),
    );
  }
}
