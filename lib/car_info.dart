import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './services/graphqlConf.dart';
import './login/loginSupport.dart';
// import './services/graphqlConf.dart';
import 'package:graphql/client.dart';
import 'package:password/password.dart';
import 'package:parkera/home.dart';
import 'package:parkera/utils/firebase_auth.dart';
import 'package:parkera/home.dart';
import 'globals.dart' as globals;

import "./addCar/addCarMut.dart";



class car_info extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _car_info();
  }
}

class _car_info extends State<car_info> {
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
            List repositories = result.data['carsByUserId'];
            print(result.data['carsByUserId'][0]['color']);

            return ListView.builder(
                itemCount: repositories.length,

                itemBuilder: (context, index) {
                  final repository = repositories[index];

                  return Text(repository['license']);
                });
          },
        )

      ),
    );

  }
}
