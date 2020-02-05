import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './signup.dart';
import './login.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                  'assets/images/appBarLogo.png',
                fit: BoxFit.cover,
                height: 95.0,
              ),
            ],
          )
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing.jpg'),
                fit: BoxFit.fill,
              )
          ),
          child: Column(
              children: <Widget>[
                Container(

                ),
                SizedBox(height: 440.0),
                Container(
                    width: 250,
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(40.0),
                      shadowColor: Colors.teal,
                      color: Colors.teal,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 20.0),
                Container(
                  width: 250,
                  height: 50.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 2.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40.0)),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                      child: Center(
                        child: Text('Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Lato')),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
