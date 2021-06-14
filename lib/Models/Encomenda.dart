import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rastreando/Models/Evento.dart';
import 'package:rastreando/Models/TipoPostal.dart';

class Encomenda{

  String codObjeto;
  String ativo;
  bool bloqueioObjeto;
  List<Evento> eventos;
  bool habilitaAutoDeclaracao;
  bool habilitaLocker;
  bool habilitaPercorridaCarteiro;
  bool permiteEncargoImportacao;
  bool possuiLocker;
  String modalidade;
  TipoPostal tipoPostal;
  String idUsuario;
  String descricao;

  Encomenda();

  Encomenda.fromDocSnap(DocumentSnapshot snapshot){
    this.codObjeto = snapshot.data()["codObjeto"];
    this.ativo = snapshot.data()["ativo"];
    this.bloqueioObjeto = snapshot.data()["bloqueioObjeto"];
    //this.eventos = snapshot.data()["eventos"];
    this.habilitaAutoDeclaracao = snapshot.data()["habilitaAutoDeclaracao"];
    this.habilitaLocker = snapshot.data()["habilitaLocker"];
    this.habilitaPercorridaCarteiro = snapshot.data()["habilitaPercorridaCarteiro"];
    this.permiteEncargoImportacao = snapshot.data()["permiteEncargoImportacao"];
    this.possuiLocker = snapshot.data()["possuiLocker"];
    this.modalidade = snapshot.data()["modalidade"];
    this.tipoPostal = TipoPostal.fromJson(snapshot.data()["tipoPostal"]);
    this.idUsuario = snapshot.data()["idUsuario"];
    this.descricao = snapshot.data()["descricao"];

    List<Evento> listaEvento = [];
    List<dynamic> lista = snapshot.data()["eventos"];
    lista.forEach((element) {
      listaEvento.add(Evento.fromJson(element));
    });
    this.eventos = listaEvento;

  }

  Encomenda.fromJson(Map<String, dynamic> jsonRaiz){

    Map<String, dynamic> json = jsonRaiz["objetos"][0];

    this.codObjeto = json["codObjeto"];
    this.ativo = json["ativo"];
    this.bloqueioObjeto = json["bloqueioObjeto"];
    this.habilitaAutoDeclaracao = json["habilitaAutoDeclaracao"];
    this.habilitaLocker = json["habilitaLocker"];
    this.habilitaPercorridaCarteiro = json["habilitaPercorridaCarteiro"];
    this.permiteEncargoImportacao = json["permiteEncargoImportacao"];
    this.possuiLocker = json["possuiLocker"];
    this.modalidade = json["modalidade"];
    this.tipoPostal = TipoPostal.fromJson(json["tipoPostal"]);

    if(true){
      List<Evento> listaEvento = [];
      List<dynamic> lista = json["eventos"];
      lista.forEach((element) {
        listaEvento.add(Evento.fromJson(element));
      });
      this.eventos = listaEvento;
    }

  }

  Map<String, dynamic> toMap(){

    List<Map<String, dynamic>> listaEventosMap = [];
    this.eventos.forEach((element) {
      listaEventosMap.add(element.toMap());
    });


    Map<String, dynamic> map = {
      "codObjeto" : this.codObjeto,
      "ativo" : this.ativo,
      "bloqueioObjeto" : this.bloqueioObjeto,
      "eventos" : listaEventosMap,
      "habilitaAutoDeclaracao" : this.habilitaAutoDeclaracao,
      "habilitaLocker" : this.habilitaLocker,
      "habilitaPercorridaCarteiro" : this.habilitaPercorridaCarteiro,
      "permiteEncargoImportacao" : this.permiteEncargoImportacao,
      "possuiLocker" : this.possuiLocker,
      "modalidade" : this.modalidade,
      "tipoPostal" : this.tipoPostal.toMap(),
      "idUsuario" : this.idUsuario,
      "descricao" : this.descricao,
    };

    return map;
  }
}