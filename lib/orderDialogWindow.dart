import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parkera/googleMapComponent.dart';
import 'package:toast/toast.dart';
import 'globals.dart' as globals;
import 'googleHelper.dart';
import 'package:parkera/CarInfo/CarDBHelper.dart';

import 'main.dart';




class orderDialog extends StatefulWidget {
  final parkPositionInfo;
  final updateParentStatus;
  orderDialog({this.parkPositionInfo, this.updateParentStatus});
  @override
  State<StatefulWidget> createState() => _orderDialog();
}
class UserCar{
  int id;
  String modelWLlicense;
  UserCar(this.id, this.modelWLlicense);
}

class _orderDialog extends State<orderDialog> {
  Map<String, dynamic> _orderInfo = new Map<String, dynamic>();
  Map<String, dynamic> _newCarInfo = new Map<String, dynamic>();
  var loaded = false;
  List<UserCar> _userCarlist = [];
  List<DropdownMenuItem<UserCar>> _dropdownMenuItems = [];
  UserCar _selectUserCar;


  @override
  void initState() {
    _orderInfo = widget.parkPositionInfo;
    super.initState();

    final GraphQLClient _client = graphQLConfiguration.clientToQuery();
    _client
        .query(QueryOptions(
      documentNode: gql(queryByUid),
      variables: <String, dynamic>{
        'nUid': globals.userid,
      },
    ))
        .then((result) {
      if (result.hasException) {
        print(result.exception.toString());
      }
      List<dynamic>  _carList = result.data['carsByUserId'].toList();
      setState(() {

        _carList.forEach((element) {
          _userCarlist.add(UserCar(element['id'], element['model']+" "+element['license']));
        });
        _dropdownMenuItems = buildDropdownMenuItems(_userCarlist);
        _dropdownMenuItems.insert(0,DropdownMenuItem(
          value: UserCar(-1,"Enter new car"),
          child: Text("Enter new car"),
        ),);
        _selectUserCar = _dropdownMenuItems[0].value;
        print(_selectUserCar.modelWLlicense);
        loaded = true;
      });
      return;
    });
  }

  List<DropdownMenuItem<UserCar>> buildDropdownMenuItems(List userCars){
    List<DropdownMenuItem<UserCar>> cars = List();
    for (UserCar userCar in userCars){
      cars.add(DropdownMenuItem(
        value: userCar,
        child: Text(userCar.modelWLlicense),
      ),);
    }
    return cars;
  }

  onChangeDropdownItem(UserCar selectUserCar){
    setState(() {
      _selectUserCar = selectUserCar;
      _orderInfo['carId'] = selectUserCar.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            value: 90,
            backgroundColor: Colors.white,
          ),
        ),
      );
    }else return AlertDialog(
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
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Select your car",style: TextStyle(fontSize: 25.0,color: Colors.green),)
                ),
                DropdownButton(
                    value: _selectUserCar,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem),
                Visibility(
                  visible: _selectUserCar.id==-1,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            maxLength: 7,
                            //controller: txtLicense,
                            onChanged: (text) {
                              setState(() {
                                _newCarInfo["license"] = text;
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
                          child: TextField(
                            maxLength: 40,
                            //controller: txtModel,
                            onChanged: (text) {
                              setState(() {
                                _newCarInfo["model"] = text;
                              });
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.text_format),
                              labelText: "Model",
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            maxLength: 40,
                            //controller: txtColor,
                            onChanged: (text) {
                              setState(() {
                                _newCarInfo["color"] = text;
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
              onPressed: () async {
                if(_selectUserCar.id==-1){
                  final GraphQLClient _client =
                  graphQLConfiguration.clientToQuery();
                  final QueryResult r = await _client.query(QueryOptions(
                      documentNode: gql(addCarMutation),
                      variables: <String, dynamic>{
                        'license': _newCarInfo['license'],
                        'model': _newCarInfo['model'],
                        'color': _newCarInfo['color'],
                        'userAccountId': globals.userid
                      }
                  )).then((result) {
                    if (result.hasException) {
                      print(result.exception.toString());
                    }
                    _orderInfo['carId'] = result.data['addCar']['id'];
                  return;
                  });
                }
                runMutation({
                  'userAccountId': globals.userid,
                  'parkSpotId':_orderInfo['id'],
                  'carInfoId':_orderInfo['carId']
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