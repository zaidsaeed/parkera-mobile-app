import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "./addParkingSpotMut.dart";
import '../globals.dart' as globals;
import 'package:toast/toast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class AlertDialogWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlertDialogWindow();
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  Map<String, String> _parkingSpotInfo = new Map<String, String>();
  TextEditingController _editingController;
  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }
  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = new
    GoogleMapsPlaces(apiKey: "AIzaSyC5VziP787dJWjz-FGiH6pica_oWyF0Yk8");  //Same API_KEY as above
    PlacesDetailsResponse detail =
    await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = prediction.description;
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
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .2),
                  child: TextField(
                    controller: _editingController,
                    maxLength: 40,
                    onTap: () async{
                      Prediction prediction = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyC5VziP787dJWjz-FGiH6pica_oWyF0Yk8",
                          mode: Mode.fullscreen, // Mode.overlay
                          language: "en",
                          components: [Component(Component.country, "ca")]);
                      if (prediction!=null){
                        setState(() {
                          _editingController.text = prediction.description;
                        });

                      }
                    },
                    onSubmitted: (text) {
                      _parkingSpotInfo['Address']=text;
                      print(_parkingSpotInfo['Address']);
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Address",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            documentNode: gql(
                addParkingSpotMutation), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show('Parking spot was not added. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              } else {
                Toast.show('Parking spot was added.', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              }
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              print(resultData);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult result,
          ) {
            return FlatButton(
              child: Text("Add Parking Spot",
                  style: TextStyle(color: Colors.teal)),
              onPressed: () {
                runMutation({
                  'address': _parkingSpotInfo['address'],
                  'userAccountId': globals.userid
                });
              },
            );
          },
        ),
        FlatButton(
            child: Text("Close", style: TextStyle(color: Colors.teal)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
