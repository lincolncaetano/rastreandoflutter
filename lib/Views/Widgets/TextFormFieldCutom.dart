import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldCustom extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final bool readOnly;
  final TextInputType type;
  final String label;
  final int maxLines;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final List<TextInputFormatter> inputFormatters;
  final InputDecoration decoration;
  final TextStyle textStyle;

  TextFormFieldCustom({
    @required this.controller,
    @required this.label,
    this.hint,
    this.readOnly = false,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.onSaved,
    this.validator,
    this.enabled = true,
    this.inputFormatters,
    this.decoration,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {

    InputDecoration decorationBase = InputDecoration(
        contentPadding:
        EdgeInsets.fromLTRB(16, 8, 16, 8),
        //hintText: this.hint,
        labelText: this.label,
        labelStyle: TextStyle(color: Color(0xfff5f5f5)),
        //filled: true,
        disabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide:  BorderSide(color: Color(0xfff5f5f5) ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xfff5f5f5) )
        )
    );

    TextStyle textStyleBase = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: TextFormField(
        controller: this.controller,
        obscureText: this.obscure,
        autofocus: this.autofocus,
        enabled: this.enabled,
        readOnly: this.readOnly,
        keyboardType: this.type,
        textAlign: TextAlign.left,
        inputFormatters: this.inputFormatters,
        style: textStyle == null ? textStyleBase : textStyle,

        decoration: decoration == null ? decorationBase : decoration,
        maxLines: this.maxLines,
        onSaved: this.onSaved,
        validator: this.validator,

      ),
    );
  }
}
