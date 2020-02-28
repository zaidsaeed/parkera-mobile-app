import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SignUpTextField extends StatefulWidget {
  final String labelText;
  final Function(String) onTextChange;
  SignUpTextField(this.labelText, this.onTextChange);

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        widget.onTextChange(text);
      },
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green))),
    );
  }
}
