import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SignUpTextField extends StatefulWidget {
  final String labelText;
  final Function(String) onTextChange;
  final String emptyErrorText;
  final String invalidErrorText;
  final TextEditingController textEditingController;
  final bool isValid;
  final bool isEmpty;

  SignUpTextField(
      {@required this.labelText,
      @required this.onTextChange,
      this.emptyErrorText,
      this.invalidErrorText,
      this.textEditingController,
      this.isValid,
      this.isEmpty});

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  String determineErrorMssg() {
    if (widget.isEmpty) {
      return widget.emptyErrorText;
    } else if (!widget.isValid) {
      return widget.invalidErrorText;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        widget.onTextChange(text);
      },
      decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: this.determineErrorMssg(),
          labelStyle: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green))),
    );
  }
}
