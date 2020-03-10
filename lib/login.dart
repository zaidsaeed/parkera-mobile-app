import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './services/graphqlConf.dart';
import './login/loginSupport.dart';
// import './services/graphqlConf.dart';
import 'package:graphql/client.dart';
import 'package:password/password.dart';
import 'package:parkera/home.dart';
import 'package:parkera/utils/firebase_auth.dart';
import 'globals.dart' as globals;


class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  Map<String, String> _AccountInfo = new Map<String, String>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: new Scaffold(
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
                              'Log In',
                              style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato'),
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
                                  _AccountInfo["email"] = text;
                                });
                                print(_AccountInfo);
                              },
                              decoration: InputDecoration(
                                  labelText: 'EMAIL',
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
                                  _AccountInfo["password"] = text;
                                });
                                print(_AccountInfo);
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
                            Container(
                              height: 40.0,
                              width: 150.0,
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
                                  onTap: () async{
                                    bool res = await AuthProvider().loginWithGoogle();
                                    if (res)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home()),
                                      );
                                    else
                                      print("Error logging in with google");
                                  },
                                  child: Center(

                                      child: FlatButton.icon( icon: Icon(Icons.mail), label: Text('Google',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato')),)

                                  ),
                                ),
                              ),
                            ),


                            // TextField(
                            //   decoration: InputDecoration(
                            //       labelText: 'NICK NAME ',
                            //       labelStyle: TextStyle(
                            //           fontFamily: 'Montserrat',
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.grey),
                            //       focusedBorder: UnderlineInputBorder(
                            //           borderSide: BorderSide(color: Colors.green))),
                            // ),
                            // SizedBox(height: 50.0),
                            Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.tealAccent,
                                  color: Colors.teal,
                                  elevation: 7.0,
                                  child: FlatButton(
                                        onPressed: () async {
                                          final GraphQLClient _client =
                                          graphQLConfiguration.clientToQuery();
                                          var _userdata = _AccountInfo.values.toList();
                                          final QueryResult result =
                                          await _client.query(QueryOptions(
                                            documentNode:
                                            gql(loginSupport.readRepositories),
                                            variables: <String, dynamic>{
                                              'nEmail': _userdata[0],
                                            },
                                          ));

                                          if (result.hasException) {
                                            print(result.exception.toString());
                                          }
                                          String reL = result.data['getAuthenticationbyEmail'][0]['password'];

                                          if(Password.verify(_userdata[1], reL)){

                                            globals.userid=result.data['getAuthenticationbyEmail'][0]['userAccountId'];
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home()),
                                            );
                                          }



                                          // var _userdata = _AccountInfo.values.toList();
                                          // print(_userdata[0]);
                                          // Query(options: QueryOptions(
                                          //     documentNode: gql(loginSupport.readRepositories),
                                          //      variables: {
                                          //     'nEmail': _userdata[0],
                                          //   }

                                          // ),
                                          //     builder: (QueryResult result,{ VoidCallback refetch, FetchMore fetchMore }) {
                                          //       if (result.hasException) {

                                          //         return Text(result.exception.toString());
                                          //       }
                                          //       if (result==null) {
                                          //         return Text("NO data found");
                                          //       }
                                          //   print("adasd"+result.data);
                                          //   return Text("yes we have");
                                          // });
                                        },
                                        child: Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Lato'),
                                          ),
                                        ),
                                      )
                                )
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
                    // GqlCaller()
                  ]))
        );
  }
}
