import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:parkera/home.dart';
import '../signup/signupMutQueries.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:password/password.dart';
import './signupHeader.dart';
import './signupTextField.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  Map<String, String> _userInfo = new Map<String, String>();
  SignUpMutQueries addUserMutation = SignUpMutQueries();
  final TextEditingController firstNameTextFieldController =
      TextEditingController();
  final TextEditingController lastNameTextFieldController =
      TextEditingController();
  final TextEditingController emailTextFieldController =
      TextEditingController();
  final TextEditingController phoneTextFieldController =
      TextEditingController();
  final TextEditingController passwordTextFieldController =
      TextEditingController();
  Map<String, bool> isEmptyMap = {
    'isFirstNameEmpty': false,
    'isLastNameEmpty': false,
    'isEmailEmpty': false,
    'isPhoneEmpty': false,
    'isPasswordEmpty': false
  };
  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    bool validateSignUp() {
      //Validate First Name
      bool valid = true;
      if (!_userInfo.keys.contains('firstname')) {
        setState(() {
          isEmptyMap['isFirstNameEmpty'] = true;
        });
        valid = false;
      } else {
        setState(() {
          isEmptyMap['isFirstNameEmpty'] = false;
        });
      }

      //Validate Last Name
      if (!_userInfo.keys.contains('lastname')) {
        setState(() {
          isEmptyMap['isLastNameEmpty'] = true;
        });
        valid = false;
      } else {
        setState(() {
          isEmptyMap['isLastNameEmpty'] = false;
        });
      }

      //Validate email
      if (!_userInfo.keys.contains('email')) {
        setState(() {
          isEmptyMap['isEmailEmpty'] = true;
        });
        valid = false;
      } else {
        RegExp exp = new RegExp(r"[^@]+@[^\.]+\..+");
        if (!exp.hasMatch(_userInfo['email'])) {
          setState(() {
            isEmailValid = false;
            isEmptyMap['isEmailEmpty'] = false;
          });
          valid = false;
        } else {
          setState(() {
            isEmptyMap['isEmailEmpty'] = false;
            isEmailValid = true;
          });
        }
      }

      //Validate Phone
      if (!_userInfo.keys.contains('phone')) {
        setState(() {
          isEmptyMap['isPhoneEmpty'] = true;
        });
        valid = false;
      } else {
        setState(() {
          isEmptyMap['isPhoneEmpty'] = false;
        });
      }

      //Validate Password
      if (!_userInfo.keys.contains('password')) {
        setState(() {
          isEmptyMap['isPasswordEmpty'] = true;
        });
        valid = false;
      } else {
        setState(() {
          isEmptyMap['isPasswordEmpty'] = false;
        });
      }
      return valid;
    }

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SignUpHeader(),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      SignUpTextField(
                        labelText: 'First Name',
                        onTextChange: (text) {
                          setState(() {
                            _userInfo["firstname"] = text;
                          });
                        },
                        emptyErrorText: 'First Name Cannot Be Empty',
                        textEditingController: firstNameTextFieldController,
                        isValid: true,
                        isEmpty: isEmptyMap['isFirstNameEmpty'],
                      ),
                      SizedBox(height: 10.0),
                      SignUpTextField(
                        labelText: 'Last Name',
                        onTextChange: (text) {
                          setState(() {
                            _userInfo["lastname"] = text;
                          });
                        },
                        emptyErrorText: 'Last Name Cannot Be Empty',
                        textEditingController: lastNameTextFieldController,
                        isValid: true,
                        isEmpty: isEmptyMap['isLastNameEmpty'],
                      ),
                      SizedBox(height: 10.0),
                      SignUpTextField(
                        labelText: 'Email',
                        onTextChange: (text) {
                          setState(() {
                            _userInfo["email"] = text;
                          });
                        },
                        emptyErrorText: 'Email Cannot Be Empty',
                        invalidErrorText: 'Email is invalid',
                        textEditingController: emailTextFieldController,
                        isValid: isEmailValid,
                        isEmpty: isEmptyMap['isEmailEmpty'],
                      ),
                      SizedBox(height: 10.0),
                      SignUpTextField(
                          labelText: 'Phone',
                          onTextChange: (text) {
                            setState(() {
                              _userInfo["phone"] = text;
                            });
                          },
                          emptyErrorText: 'Phone Cannot Be Empty',
                          textEditingController: phoneTextFieldController,
                          isEmpty: isEmptyMap['isPhoneEmpty'],
                          isValid: true),
                      SizedBox(height: 10.0),
                      SignUpTextField(
                        labelText: 'Password',
                        onTextChange: (text) {
                          setState(() {
                            _userInfo["password"] = text;
                          });
                        },
                        emptyErrorText: 'Password Cannot Be Empty',
                        textEditingController: passwordTextFieldController,
                        isEmpty: isEmptyMap['isPasswordEmpty'],
                        isValid: true,
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
                                      print(_userInfo);
                                      bool isValid = validateSignUp();
                                      if (isValid) {
                                        var _userdata =
                                            _userInfo.values.toList();
                                        runMutation({
                                          'firstname': _userdata[0],
                                          'lastname': _userdata[1],
                                          'email': _userdata[2],
                                          'phone': _userdata[3],
                                          'user_role': 'User',
                                          'password': Password.hash(
                                              _userdata[4], new PBKDF2())
                                        });
                                      } else {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Please refer to the errors included in the form.'),
                                        ));
                                      }

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => Home()),
                                      // );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(fontFamily: 'Lato'),
                                    ),
                                  ),
                                )),
                          );
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
            ]));
  }
}
