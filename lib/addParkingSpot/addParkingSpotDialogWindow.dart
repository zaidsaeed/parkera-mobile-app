import "package:flutter/material.dart";
// import "../services/graphqlConf.dart";
// import "../services/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
// import "package:example/components/person.dart";
import "./addParkingSpotMut.dart";

class AlertDialogWindow extends StatefulWidget {
  // final Person person;
  // final bool isAdd;

  @override
  State<StatefulWidget> createState() => _AlertDialogWindow();
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  Map<String, String> _parkingSpotInfo = new Map<String,String>();
  // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  // QueryMutation addMutation = QueryMutation();

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
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    onChanged: (text){
                      _parkingSpotInfo['address']=text;
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
            documentNode: gql(addParkingSpotMutation), // this is the mutation string you just created
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
            return  FlatButton(
              child: Text("Add Parking Spot"),
              onPressed: () {runMutation({
                'address': _parkingSpotInfo['address']
              });
              Navigator.of(context).pop();
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
