import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './signup.dart';
import './login.dart';

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
          child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    "to Log In",
                  ),
                ),
                FlatButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
