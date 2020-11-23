import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'googleHelper.dart';
import 'package:parkera/orderDialogWindow.dart';
import 'main.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
LatLng SOURCE_LOCATION = LatLng(45.425533, -75.692482);

class googleMapComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _googleMapComponent();
  }
}


class _googleMapComponent extends State<googleMapComponent> {
  GoogleMapController mapController;

  double selectedLat;
  double selectedLng;
  bool _isOrderVisible;
  String _price;
  String _parkposition;
  LatLng sourceLoc;
  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  final List<Widget> _pages = <Widget>[];
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      sourceLoc = LatLng(position.latitude, position.longitude);
    });
    if(sourceLoc!=null){
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 15,tilt: 50.0,
        bearing: 45.0,)));
    }
    print(sourceLoc);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isOrderVisible = false;
      _price = "";
      _parkposition = "";
    });
  }




  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    return Expanded (
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: initialCameraPosition,
            markers: _markers.values.toSet(),
            polylines: _polyLines,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                15.0,
                MediaQuery.of(context).size.height * .1,
                0.0,
                0.0),
            child: SearchMapPlaceWidget(
              hasClearButton: true,
              placeType: PlaceType.address,
              placeholder: 'Enter destination',
              apiKey: 'AIzaSyC5VziP787dJWjz-FGiH6pica_oWyF0Yk8',

              onSelected: (Place place) async{
                setState(() {
                  _pages.clear();
                  _markers.clear();
                });
                Geolocation geolocation = await place.geolocation;
                mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                print(geolocation.coordinates.toString());
                LatLng areaLocation = geolocation.coordinates;

                final GraphQLClient _client =
                graphQLConfiguration.clientToQuery();
                final QueryResult r = await _client.query(QueryOptions(
                    documentNode: gql(searchNear),
                    variables: <String, dynamic>{
                      'dlatitude': areaLocation.latitude,
                      'dlongitude':areaLocation.longitude

                // ignore: missing_return
                },)).then((result) {
                    if (result.hasException) {
                      print(result.exception.toString());
                    }
                    List<dynamic> parkingSpotsInfo = result.data['searchNear'].toList();
                    parkingSpotsInfo.forEach((element) {
                      LatLng spotLL = new LatLng(element['latitude'], element['longitude']);
                      setState(() {
                        _pages.add(ResultInfoWindow(spotLL,element['address'],element['price'].toString()));
                        createMarker(spotLL,element['id'].toString(),element['address'],element['price'].toString());
                      });
                    });

                    return;
                });


              },
            ),
          ),AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            bottom: 0,
            child:Visibility(
              visible: (_pages.length>0),
              child: Container(
                color: Colors.white.withOpacity(0.8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                        height: 55.0,
                        width: MediaQuery.of(context).size.width*0.7,
                        margin: EdgeInsets.only(top:10,bottom: 65),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(30.0)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: Offset(0, 0.5),
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: PageView(
                          onPageChanged: (int page){
                            setState(() {
                              _isOrderVisible = false;
                            });
                          },
                          children: _pages,
                        )
                    ),

                  ],
                ),

              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
                visible: _isOrderVisible,
                child: Container(
                  height: 45,
                  padding: EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.navigation),
                    onPressed: () => _orderDialog(context,_parkposition,_price),
                    label: Text("Order"),
                    backgroundColor: Colors.green,
                  ),
                )
            ),
          )
        ],
      )



    );

  }

  void _orderDialog(context, parkaddress, parkprice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        orderDialog orderWindow = new orderDialog(
          parkposition : parkaddress,
          price: parkprice,
        );
        return orderWindow;
      },
    );
  }

  void createMarker(LatLng position, String id, String address, String price ){
    final marker2 = Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(
        title: address,
        snippet: '\$'+price,
      ),

    );
    _markers[id] = marker2;
  }



  Widget ResultInfoWindow(LatLng destination, String name, String price){
    return GestureDetector(
      onTap: () {
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination, zoom: 15,tilt: 50.0,
          bearing: 45.0,)));
        setState(() {
          _isOrderVisible = true;
          _parkposition = name;
          _price = price;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child: Container(
              child: Text(name,style: TextStyle(fontSize: 25.0,color: Colors.green),overflow: TextOverflow.ellipsis,)
          ),),
          Container(
            child: Text("(\$"+price+")",style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}

