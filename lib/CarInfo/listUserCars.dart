import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/graphqlConf.dart';
import 'package:graphql/client.dart';
import 'package:parkera/home/home.dart';
import 'package:parkera/globals.dart' as globals;

import 'modifyCarInfoDialog.dart';
import 'addCarInfoAlertDialogWindow.dart';
import 'CarDBHelper.dart';

class listUserCars extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _listUserCars();
  }
}

void _updateCarInfo(context, carInfo, updateParentStatus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      ModifyCarInfoDialog carInalertDialogWindow = new ModifyCarInfoDialog(
        carInfo: carInfo,
        updateParentStatus: updateParentStatus,
      );
      return carInalertDialogWindow;
    },
  );
}
void _addCarInfo(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      carInfoAlertDialog carInalertDialogWindow = new carInfoAlertDialog();
      return carInalertDialogWindow;
    },
  );
}

class _listUserCars extends State<listUserCars> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  var loaded = false;
  var usercarinfos;
  void initState() {
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
      setState(() {
        usercarinfos = result.data['carsByUserId'];
        loaded = true;
      });
      return;
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
    } else {
      return MaterialApp(
        home: new Scaffold(
          appBar: AppBar(
            title: Text("Your Cars"),
            backgroundColor: Colors.teal,
          ),
          body: ListView.builder(
              itemCount: this.usercarinfos.length,
              itemBuilder: (context, index) {
                final carInfo = this.usercarinfos[index];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(carInfo['license']),
                        subtitle: Text(carInfo['model']),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Modify',
                                style: TextStyle(color: Colors.teal)),
                            onPressed: () => _updateCarInfo(context, carInfo,
                                (modifiedCarInfo) {
                              setState(() {
                                usercarinfos[index] = modifiedCarInfo;
                              });
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.directions_car),
            backgroundColor: Colors.teal,
            onPressed: () => _addCarInfo(context),
            label: Text(
              'Add Car',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.teal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    })
              ],
            ),
          ),
        ),
      );
    }
  }
}
