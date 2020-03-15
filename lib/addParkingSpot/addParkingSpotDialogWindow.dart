import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "./addParkingSpotMut.dart";
import '../globals.dart' as globals;
import 'package:toast/toast.dart';

class AlertDialogWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlertDialogWindow();
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  Map<String, String> _parkingSpotInfo = new Map<String, String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Parking Spot"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .2),
                  child: TextField(
                    maxLength: 40,
                    onChanged: (text) {
                      _parkingSpotInfo['address'] = text;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Address",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            documentNode: gql(
                addParkingSpotMutation), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show('Parking spot was not added. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              } else {
                Toast.show('Parking spot was added.', context,
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
              child: Text("Add Parking Spot"),
              onPressed: () {
                runMutation({
                  'address': _parkingSpotInfo['address'],
                  'userAccountId': globals.userid
                });
              },
            );
          },
        ),
        FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
