import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'parkingSpotHelper.dart';
import 'listParkingSpot.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class modifyParkingSpotDialog extends StatefulWidget {
  final parkingSpotInfo;
  final updateParentStatus;
  modifyParkingSpotDialog({this.parkingSpotInfo, this.updateParentStatus});

  @override
  State<StatefulWidget> createState() => _modifyParkingSpotDialog();
}

class _modifyParkingSpotDialog extends State<modifyParkingSpotDialog> {
  Map<String, String> _parkingSpotInfo = new Map<String, String>();
  TextEditingController _editingController;



  @override
  void initState() {
    _parkingSpotInfo["address"] = widget.parkingSpotInfo['address'];
    _parkingSpotInfo["price"] = widget.parkingSpotInfo['price'].toString();
    _parkingSpotInfo["latitude"] = widget.parkingSpotInfo['latitude'].toString();
    _parkingSpotInfo["longitude"] = widget.parkingSpotInfo['longitude'].toString();
    _editingController = TextEditingController();
    _editingController.text = widget.parkingSpotInfo['address'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Parking Spot Information"),
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
                    controller: _editingController,
                    maxLength: 60,
                    onTap: () async{
                      Prediction prediction = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyC5VziP787dJWjz-FGiH6pica_oWyF0Yk8",
                          mode: Mode.overlay, // Mode.overlay
                          language: "en",
                          components: [Component(Component.country, "ca")]);
                      if (prediction!=null){
                        GoogleMapsPlaces _places = new
                        GoogleMapsPlaces(apiKey: "AIzaSyC5VziP787dJWjz-FGiH6pica_oWyF0Yk8");
                        PlacesDetailsResponse detail =
                        await _places.getDetailsByPlaceId(prediction.placeId);
                        setState(() {
                          _editingController.text = prediction.description;
                          _parkingSpotInfo['latitude']= detail.result.geometry.location.lat.toString();
                          _parkingSpotInfo['longitude'] = detail.result.geometry.location.lng.toString();
                          _parkingSpotInfo['address']=prediction.description;

                        });
                      }
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_rotate_vertical),
                      labelText: "Address",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextFormField(
                    maxLength: 40,
                    initialValue: _parkingSpotInfo["price"],
                    onChanged: (text) {
                      setState(() {
                        _parkingSpotInfo["price"] = text;
                        print(_parkingSpotInfo);
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Price",
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
            documentNode:
            gql(updateParkingSpot), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              if (result.hasException) {
                Toast.show(
                    'Parking Spot information was not updated successfully. An error has occurred',
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
              } else {
                Toast.show(
                    'Parking Spot Information was successfully modified.', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => listParkingSpots()),
              );
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              widget.updateParentStatus(resultData.data['updateParkingSpot']);
              print(resultData);
            },
          ),
          builder: (
              RunMutation runMutation,
              QueryResult result,
              ) {
            return FlatButton(
              child:
              Text("Modify Parking Spot Info", style: TextStyle(color: Colors.teal)),
              onPressed: () {
                runMutation({
                  'id': widget.parkingSpotInfo['id'],
                  'address': _parkingSpotInfo['address'],
                  'latitude': double.parse(_parkingSpotInfo['latitude']),
                  'longitude': double.parse(_parkingSpotInfo['longitude']),
                  'price': double.parse(_parkingSpotInfo['price'])
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
