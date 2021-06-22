import 'package:flutter/material.dart';
import 'package:rastreando/Palleta.dart';

class ElevatedButtonCustom extends StatelessWidget {

  final String label;
  final Function onPressed;

  ElevatedButtonCustom({
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        label,
        style: TextStyle(
          color: Palleta.body2,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(Palleta.getColor2)
      ),
      onPressed: onPressed
    );
  }
}
