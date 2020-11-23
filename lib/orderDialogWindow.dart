import "package:flutter/material.dart";


class orderDialog extends StatefulWidget {
  final parkposition;
  final price;
  orderDialog({this.parkposition, this.price});

  @override
  State<StatefulWidget> createState() => _orderDialog();
}

class _orderDialog extends State<orderDialog> {
  Map<String, String> _orderInfo = new Map<String, String>();

  @override
  void initState() {
    _orderInfo["address"] = widget.parkposition;
    _orderInfo["price"] = widget.price;
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
                    child: Text(widget.parkposition,style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
                ),

              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        /*Mutation(
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

              },
            );
          },
        ),*/
        FlatButton(
            child: Text("Close", style: TextStyle(color: Colors.teal)),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}