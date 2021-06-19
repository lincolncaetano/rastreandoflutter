import 'package:flutter/material.dart';

class Palleta {
  // background gradient

  static Color botao = Color(0xfff5f5f5);
  static Color contrasteEscuro = Color(0xff2d2d3a);
  static Color corTeste = Color(0xff22272c);
  static Color corTextoTeste = Color(0xffc2ad7d);

  static Color body1 = Color(0xff010101);
  static Color tabs1 = Color(0xff171717);
  static Color cinza1 = Color(0xff1D1D1F);

  static Color body2 = Color(0xFF284E83);
  static Color tabs2 = Color(0xFF284E83);
  static Color cinza2 = Color(0xff2A2B2F);
  static Color vermelho = Color(0xffFF596B);




  static Color tabs = Color(0xff2e343b);

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return botao;
    }
    return botao;
  }
}