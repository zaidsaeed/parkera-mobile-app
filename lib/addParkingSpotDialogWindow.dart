import "package:flutter/material.dart";
// import "../services/graphqlConf.dart";
// import "../services/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
// import "package:example/components/person.dart";

class AlertDialogWindow extends StatefulWidget {
  // final Person person;
  // final bool isAdd;

  @override
  State<StatefulWidget> createState() => _AlertDialogWindow();
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtAge = TextEditingController();
  // GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  // QueryMutation addMutation = QueryMutation();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Parking Spot"),
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
                    maxLength: 5,
                    controller: txtId,
                    // enabled: this.isAdd,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "ID",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Name",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtLastName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Last name",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 240.0),
                  child: TextField(
                    maxLength: 2,
                    controller: txtAge,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Age", icon: Icon(Icons.calendar_today)),
                  ),
                ),
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
          child: Text("Add Parking Spot"),
          onPressed: () {},
        )
      ],
    );
  }
}
