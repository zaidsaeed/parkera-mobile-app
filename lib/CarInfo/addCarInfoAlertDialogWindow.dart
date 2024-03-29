import "package:flutter/material.dart";
// import "../services/graphqlConf.dart";
// import "../services/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
// import "package:example/components/person.dart";
import "./CarDBHelper.dart";
import 'package:parkera/globals.dart' as globals;
import 'package:toast/toast.dart';

class carInfoAlertDialog extends StatefulWidget {
  // final Person person;
  // final bool isAdd;

  @override
  State<StatefulWidget> createState() => _carInfoAlertDialog();
}

class _carInfoAlertDialog extends State<carInfoAlertDialog> {
  Map<String, String> _carInfo = new Map<String, String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Car Information"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: TextField(
                    maxLength: 7,
                    //controller: txtLicense,
                    onChanged: (text) {
                      setState(() {
                        _carInfo["license"] = text;
                      });
                    },
                    // enabled: this.isAdd,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "License",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    //controller: txtModel,
                    onChanged: (text) {
                      setState(() {
                        _carInfo["model"] = text;
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Model",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    //controller: txtColor,
                    onChanged: (text) {
                      setState(() {
                        _carInfo["color"] = text;
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Color",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            documentNode: gql(
                addCarMutation), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show(
                    'Car Information was not added. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              } else {
                Toast.show('Car Information was added.', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              }
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
            return FlatButton(
              child: Text("Add Car Info", style: TextStyle(color: Colors.teal)),
              onPressed: () {
                runMutation({
                  'license': _carInfo['license'],
                  'model': _carInfo['model'],
                  'color': _carInfo['color'],
                  'userAccountId': globals.userid
                });
              },
            );
          },
        ),
        FlatButton(
            child: Text("Close", style: TextStyle(color: Colors.teal)),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
