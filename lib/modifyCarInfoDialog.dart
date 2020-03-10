import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "./addCar/addCarMut.dart";
import 'listUserCars.dart';

class ModifyCarInfoDialog extends StatefulWidget {
  final carInfo;
  final updateParentStatus;
  ModifyCarInfoDialog({this.carInfo,this.updateParentStatus});

  // final Person person;
  // final bool isAdd;

  @override
  State<StatefulWidget> createState() => _modifyCarInfoDialog();
}

class _modifyCarInfoDialog extends State<ModifyCarInfoDialog> {
  Map<String, String> _carInfo = new Map<String,String>();
  //TextEditingController txLicense = TextEditingController();
  //TextEditingController txtModel = TextEditingController();
  //TextEditingController txtColor = TextEditingController();
  // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  // QueryMutation addMutation = QueryMutation();

  @override
  void initState() {
    _carInfo["license"]=widget.carInfo['license'];
    _carInfo["model"]=widget.carInfo['model'];
    _carInfo["color"]=widget.carInfo['color'];
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
                  child: TextFormField(
                    initialValue: widget.carInfo['license'],
                    maxLength: 7,
                    //controller: txtLicense,
                    onChanged: (text){
                      setState(() {
                        _carInfo["license"]=text;
                        print(_carInfo);
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
                  child: TextFormField(
                    maxLength: 40,
                    initialValue: widget.carInfo['model'],
                    //controller: txtModel,
                    onChanged: (text){
                      setState(() {
                        _carInfo["model"]=text;
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
                    //controller: txtColor,
                    onChanged: (text){
                      setState(() {
                        _carInfo["color"]=text;
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
            documentNode: gql(updateCar), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              print(result);
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              var tmp = resultData.data['updateCar'][0];
              widget.updateParentStatus(resultData.data['updateCar']);
              print(resultData);
            },
          ),
          builder: (
              RunMutation runMutation,
              QueryResult result,
              ) {
            return  FlatButton(
              child: Text("Modify Car Info"),
              onPressed: () {runMutation({
                'id':widget.carInfo['id'],
                'license': _carInfo['license'],
                'model': _carInfo['model'],
                'color': _carInfo['color']
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => listUserCars()),
              );
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
