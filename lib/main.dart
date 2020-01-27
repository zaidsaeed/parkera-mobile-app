import './signup.dart';
import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import "services/graphqlConf.dart";

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
      GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(child: MyApp()),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Scaffold(body: SignUp()));
  }
}
