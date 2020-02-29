import "package:flutter/material.dart";
// import "../services/graphqlConf.dart";
// import "../services/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
// import "package:example/components/person.dart";

class carInfoAlertDialog extends StatefulWidget {
  // final Person person;
  // final bool isAdd;

  @override
  State<StatefulWidget> createState() => _carInfoAlertDialog();
}

class _carInfoAlertDialog extends State<carInfoAlertDialog> {
  TextEditingController txLicense = TextEditingController();
  TextEditingController txtModel = TextEditingController();
  TextEditingController txtColor = TextEditingController();
  // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  // QueryMutation addMutation = QueryMutation();

  @override
  void initState() {
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
                  child: TextField(
                    maxLength: 7,
                    controller: txLicense,
                    // enabled: this.isAdd,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "License",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtModel,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Model",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtColor,
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
        FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
          child: Text("Add Car Info"),
          onPressed: () {},
        )
      ],
    );
  }
}
