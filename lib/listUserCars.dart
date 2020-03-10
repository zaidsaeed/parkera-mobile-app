import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './services/graphqlConf.dart';
// import './services/graphqlConf.dart';
import 'package:graphql/client.dart';
import 'globals.dart' as globals;

import 'modifyCarInfoDialog.dart';

import "./addCar/addCarMut.dart";



class listUserCars extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _listUserCars();
  }
}

void _updateCarInfo(context,carInfo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      ModifyCarInfoDialog carInalertDialogWindow = new ModifyCarInfoDialog(carInfo:carInfo,);
      return carInalertDialogWindow;
    },
  );
}

class _listUserCars extends State<listUserCars> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body:
        Query(
          options: QueryOptions(
              documentNode: gql(queryByUid), // this is the query string you just created
              variables: <String, dynamic>{
                'nUid': globals.userid,
              }
          ),
          // Just like in apollo refetch() could be used to manually trigger a refetch
          // while fetchMore() can be used for pagination purpose
          builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
            int uid = globals.userid;
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading) {
              return Text('Loading');
            }

            // it can be either Map or List
            List carInfos = result.data['carsByUserId'];
            return ListView.builder(
                itemCount: carInfos.length,

                itemBuilder: (context, index) {
                  final carInfo = carInfos[index];
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
                                child: const Text('Modify'),
                                onPressed: () => _updateCarInfo(context,carInfo),
                              ),
                            ],
                          ),
                        ],
                      ),
                  );
                });
          },
        )

      ),
    );

  }
}
