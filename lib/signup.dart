import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:parkera/home.dart';
import 'package:parkera/landing.dart';
import './services/graphqlConf.dart';
import './signup/signupMutQueries.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:password/password.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  Map<String, String> _userInfo = new Map<String, String>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  SignUpMutQueries addUserMutation = SignUpMutQueries();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            _userInfo["firstname"] = text;
                          });
                          print(_userInfo);
                        },
                        decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            _userInfo["lastname"] = text;
                          });
                          print(_userInfo);
                        },
                        decoration: InputDecoration(
                            labelText: 'LAST NAME',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            _userInfo["email"] = text;
                          });
                          print(_userInfo);
                        },
                        decoration: InputDecoration(
                            labelText: 'EMAIL ',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            _userInfo["phone"] = text;
                          });
                          print(_userInfo);
                        },
                        decoration: InputDecoration(
                            labelText: 'PHONE ',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (text) {
                          setState(() {
                            _userInfo["password"] = text;
                          });
                          print(_userInfo);
                        },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
                            labelStyle: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
                      Mutation(
                        options: MutationOptions(
                          documentNode: gql(addUserMutation
                              .addUser), // this is the mutation string you just created
                          // you can update the cache based on results
                          update: (Cache cache, QueryResult result) {
                            print(result);
                            return cache;
                          },
                          // or do something with the result.data on completion
                          onCompleted: (dynamic resultData) {
                            print(resultData);
                          },
                        ),
                        builder: (
                          RunMutation runMutation,
                          QueryResult result,
                        ) {
                          return Container(
                            height: 40.0,
                            color: Colors.transparent,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: () {
                                      var _userdata = _userInfo.values.toList();
                                      runMutation({
                                        'firstname': _userdata[0],
                                        'lastname': _userdata[1],
                                        'email': _userdata[2],
                                        'phone': _userdata[3],
                                        'user_role': 'User',
                                        'password': Password.hash(
                                            _userdata[4], new PBKDF2())
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(fontFamily: 'Lato'),
                                    ),
                                  ),
                                )),
                          );

                          // return FloatingActionButton(
                          //   onPressed: () {
                          //     var _userdata = _userInfo.values.toList();
                          //     runMutation({
                          //       'firstname': _userdata[0],
                          //       'lastname': _userdata[1],
                          //       'email': _userdata[2],
                          //       'phone': _userdata[3],
                          //       'user_role': 'User',
                          //       'password':
                          //           Password.hash(_userdata[4], new PBKDF2())
                          //     });
                          //   },
                          //   tooltip: 'Star',
                          //   child: Icon(Icons.star),
                          // );
                        },
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text('Go Back',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lato')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Center(
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: Text(
                    "Navigate To Homepage",
                    style: TextStyle(fontFamily: 'Lato'),
                  ),
                ),
              )
              // SizedBox(height: 15.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       'New to Spotify?',
              //       style: TextStyle(
              //         fontFamily: 'Montserrat',
              //       ),
              //     ),
              //     SizedBox(width: 5.0),
              //     InkWell(
              //       child: Text('Register',
              //           style: TextStyle(
              //               color: Colors.green,
              //               fontFamily: 'Montserrat',
              //               fontWeight: FontWeight.bold,
              //               decoration: TextDecoration.underline)),
              //     )
              //   ],
              // )
            ]));
  }
}
