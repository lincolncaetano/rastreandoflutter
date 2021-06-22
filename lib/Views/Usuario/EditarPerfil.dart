import 'dart:ui';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:rastreando/Models/Usuario.dart';
import 'package:rastreando/Utils/FireUtils.dart';
import 'package:rastreando/Views/Widgets/ElevatedButtonCustom.dart';
import 'package:rastreando/Views/Widgets/TextFormFieldCutom.dart';
import 'package:validadores/Validador.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  FirebaseFirestore db = FirebaseFirestore.instance;
  Usuario usuario;
  User user;
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  static final _formKey = new GlobalKey<FormState>();
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
      _controllerEmail.text = usuario.email;
      _controllerCpf.text = usuario.cpf;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerCpf.dispose();
    _controllerCelular.dispose();
    _controllerDataNasc.dispose();
    super.dispose();
  }

  _getFoto() async{
    try {
      final pickedFile = await _picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 70
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        //_pickImageError = e;
      });
    }
  }

/*  foto(){
    if(_imageFile != null){
        return FileImage(File(_imageFile.path));
    }else if(usuario.foto != null){
      return NetworkImage(usuario.foto);
    }else{
      return null;
    }
  }*/

  _salvarPefil() async{

    /*if(_imageFile != null){
      usuario.foto = await _uploadImage(_imageFile.path);
    }*/

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("usuarios")
        .doc(user.uid)
        .update(usuario.toMap());


    Navigator.pop(context);
  }

  Future<dynamic> _uploadImage(String imagePath) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    String image = imagePath.replaceAll("file://", "");

    Reference arquivo = pastaRaiz.child("usuarios").child(user.uid.toString()+".jpg");
    UploadTask uploadTask = arquivo.putFile(File(image));
    TaskSnapshot snapshot = await uploadTask;

    String url = await snapshot.ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil", style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _getFoto();
                    },
                    child: Container(
                      //padding: const EdgeInsets.all(2.0),
                      decoration: new BoxDecoration(
                        //color: Colors.black, // border color
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.8),
                                offset: Offset(0, 5) ,
                                blurRadius: 10
                            )
                          ]
                      ),
                      child: usuario != null ?
                      CircleAvatar(
                        maxRadius: MediaQuery.of(context).size.width / 6 ,
                        backgroundColor: Colors.grey,
                       // backgroundImage: foto()
                      ): CircleAvatar(
                        maxRadius: MediaQuery.of(context).size.width / 6 ,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric( vertical: 15)),
              TextFormFieldCustom(
                controller: _controllerNome,
                label: "Nome",
                type: TextInputType.text,
                onSaved: (nome){
                 // usuario.nome = nome;
                },
                validator: (valor){},),
              TextFormFieldCustom(
                controller: _controllerEmail,
                label: "Email",
                type: TextInputType.emailAddress,
                onSaved: (email){
                  usuario.email = email;
                },
                validator: (valor){},),
                ElevatedButtonCustom(
                    label: "Salvar",
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();

                        _salvarPefil();

                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
