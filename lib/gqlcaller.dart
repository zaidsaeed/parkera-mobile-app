import 'package:flutter/widgets.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import './services/graphqlConf.dart';
import './queries.dart';

class GqlCaller extends StatelessWidget {
  void callQuery() async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    Queries queries = Queries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queries.getAll()),
      ),
    );
    print("query result");
    result.data.forEach((key, value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    callQuery();
    return Text("hello");
  }
}
