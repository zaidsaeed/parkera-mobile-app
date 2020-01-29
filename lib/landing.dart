import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './signup.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkera',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dummy Landing page'),
        ),
        body: Center(
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            child: Text(
              "Navigate To SignUp",
            ),
          ),
        ),
      ),
    );
  }
}
