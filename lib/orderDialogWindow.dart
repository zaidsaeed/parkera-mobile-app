import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parkera/googleMapComponent.dart';
import 'package:toast/toast.dart';
import 'globals.dart' as globals;
import 'googleHelper.dart';




class orderDialog extends StatefulWidget {
  final parkPositionInfo;
  final updateParentStatus;
  orderDialog({this.parkPositionInfo, this.updateParentStatus});
  @override
  State<StatefulWidget> createState() => _orderDialog();
}

class _orderDialog extends State<orderDialog> {
  Map<String, dynamic> _orderInfo = new Map<String, dynamic>();

  @override
  void initState() {
    _orderInfo = widget.parkPositionInfo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ready to booking"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text("You will park at: ",style: TextStyle(fontSize: 25.0,color: Colors.green),)
                ),
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(_orderInfo['address'],style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
                ),

              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            documentNode:
            gql(addOrder), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show(
                    'Ordering parking Spot was not updated successfully. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
              } else {
                Toast.show(
                    'Ordering parking Spot was successfully modified.', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => googleMapComponent()),
              );
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              widget.updateParentStatus(_orderInfo);
            },
          ),
          builder: (
              RunMutation runMutation,
              QueryResult result,
              ) {
            return FlatButton(
              child:
              Text("Ordered", style: TextStyle(color: Colors.teal)),
              onPressed: () {
                runMutation({
                  'userAccountId': globals.userid,
                  'parkSpotId':_orderInfo['id'],
                });},
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