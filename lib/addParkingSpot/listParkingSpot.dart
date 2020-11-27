import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/graphqlConf.dart';
import 'package:graphql/client.dart';
import 'package:parkera/home/home.dart';
import 'package:parkera/globals.dart' as globals;

import 'modifyParkingSpot.dart';
import 'addParkingSpotDialogWindow.dart';

import 'parkingSpotHelper.dart';

class listParkingSpots extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _listParkingSpots();
  }
}

void _addParkingSpot(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      AlertDialogWindow alertDialogWindow = new AlertDialogWindow();
      return alertDialogWindow;
    },
  );
}

void _updateParkingSpotInfo(context, parkingSpotInfo, updateParentStatus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      modifyParkingSpotDialog modifyParkingSpotWindow = new modifyParkingSpotDialog(
        parkingSpotInfo: parkingSpotInfo,
        updateParentStatus: updateParentStatus,
      );
      return modifyParkingSpotWindow;
    },
  );
}

class _listParkingSpots extends State<listParkingSpots> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  var loaded = false;
  var parkingSpotsInfo;
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
        parkingSpotsInfo = result.data['parkingSpotsByUserId'];
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
            title: Text("Your Parking Spots"),
            backgroundColor: Colors.teal,
          ),
          body: ListView.builder(
              itemCount: this.parkingSpotsInfo.length,
              itemBuilder: (context, index) {
                final parkingSpotsInfo = this.parkingSpotsInfo[index];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(parkingSpotsInfo['address']),
                        subtitle: Text(parkingSpotsInfo['price'].toString()),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Modify',
                                style: TextStyle(color: Colors.teal)),
                            onPressed: () => _updateParkingSpotInfo(context, parkingSpotsInfo,
                                    (modifiedParkingSpotsInfo) {
                                  setState(() {
                                    this.parkingSpotsInfo[index]=modifiedParkingSpotsInfo;
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
              icon: Icon(Icons.local_parking),
              backgroundColor: Colors.teal,
              onPressed: () => _addParkingSpot(context),
              label: Text(
                'Add Parking Spot',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),)
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
