import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Palleta.dart';
import 'package:rastreando/Routers.dart';
import 'package:rastreando/Views/Widgets/ElevatedButtonCustom.dart';
import 'package:rastreando/Views/Widgets/TextFormFieldCutom.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static final _formKey = new GlobalKey<FormState>();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();

  String _nome;
  String _email;
  String _senha;
  String _celular;

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

  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((value){

      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuarios")
          .doc(value.user.uid)
          .set( usuario.toMap());


      //Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) => Home()));
      Navigator.pushNamedAndRemoveUntil(context, Routers.tabs, (route) => false);
    })
        .catchError((onError){
      print(onError);
      if(onError.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Email já cadastrado!"),
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Cadastro", style: TextStyle(color: Palleta.botao),),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            margin: EdgeInsets.symmetric( horizontal: 10),
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
                    child: Text("Cadastro" , style: TextStyle(color: Palleta.body2, fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  TextFormFieldCustom(
                    controller: _controllerEmail,
                    label: "Email",
                    type: TextInputType.emailAddress,
                    textStyle: TextStyle(color: Palleta.body2),
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(16, 8, 16, 8),
                        //hintText: "E-mail",
                        labelText: "E-mail",
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
                    onSaved: (email){
                      _email = email;
                    },
                    validator: (valor){},),
                  TextFormFieldCustom(
                    controller: _controllerSenha,
                    label: "Senha",
                    type: TextInputType.text,
                    textStyle: TextStyle(color: Palleta.body2),
                    obscure: true,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(16, 8, 16, 8),
                          //hintText: "E-mail",
                          labelText: "Senha",
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
                    onSaved: (senha){
                      _senha = senha;
                    },
                    validator: (valor){},),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButtonCustom(
                        label: "Cadastrar",
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();

                            Usuario u = Usuario();
                            u.email = _email;
                            u.senha = _senha;

                            _cadastrarUsuario(u);

                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
