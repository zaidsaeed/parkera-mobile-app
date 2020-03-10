import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'CarDBHelper.dart';
import 'listUserCars.dart';
import 'package:toast/toast.dart';

class ModifyCarInfoDialog extends StatefulWidget {
  final carInfo;
  final updateParentStatus;
  ModifyCarInfoDialog({this.carInfo, this.updateParentStatus});

  @override
  State<StatefulWidget> createState() => _modifyCarInfoDialog();
}

class _modifyCarInfoDialog extends State<ModifyCarInfoDialog> {
  Map<String, String> _carInfo = new Map<String, String>();

  @override
  void initState() {
    _carInfo["license"] = widget.carInfo['license'];
    _carInfo["model"] = widget.carInfo['model'];
    _carInfo["color"] = widget.carInfo['color'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Car Information"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    initialValue: widget.carInfo['license'],
                    maxLength: 7,
                    onChanged: (text) {
                      setState(() {
                        _carInfo["license"] = text;
                        print(_carInfo);
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "License",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextFormField(
                    maxLength: 40,
                    initialValue: widget.carInfo['model'],
                    onChanged: (text) {
                      setState(() {
                        _carInfo["model"] = text;
                        print(_carInfo);
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
                  child: TextFormField(
                    maxLength: 40,
                    initialValue: widget.carInfo['color'],
                    onChanged: (text) {
                      setState(() {
                        _carInfo["color"] = text;
                        print(_carInfo);
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
            documentNode:
                gql(updateCar), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show(
                    'Car information was not updated successfully. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
              } else {
                Toast.show(
                    'Car Information was successfully modified.', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => listUserCars()),
              );
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              widget.updateParentStatus(resultData.data['updateCar']);
              print(resultData);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult result,
          ) {
            return FlatButton(
              child: Text("Modify Car Info"),
              onPressed: () {
                runMutation({
                  'id': widget.carInfo['id'],
                  'license': _carInfo['license'],
                  'model': _carInfo['model'],
                  'color': _carInfo['color']
                });
              },
            );
          },
        ),
        FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
