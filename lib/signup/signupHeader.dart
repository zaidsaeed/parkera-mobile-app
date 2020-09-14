import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .04,
                MediaQuery.of(context).size.height * .1,
                0.0,
                0.0),
            child: Text(
              'Signup',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .09,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
    );
  }
}
