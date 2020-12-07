import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'googleHelper.dart';
import 'package:parkera/orderDialogWindow.dart';
import 'main.dart';
import 'package:parkera/googleMapsServices.dart';


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


class _googleMapComponent extends State<googleMapComponent> with TickerProviderStateMixin{
  GoogleMapController mapController;
  googleMapsServices _googleMapsServices = googleMapsServices();
  double selectedLat;
  double selectedLng;
  bool _isOrderVisible;
  bool _isBooked;
  String modelWLlicense;
  Map<String, dynamic> _parkposition = new Map<String, dynamic>();
  LatLng sourceLoc;
  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  final List<Widget> _pages = <Widget>[];
  AnimationController _animationController;
  int _bId;

  String get timerString{
    Duration duration = _animationController.duration * _animationController.value;
    return '${duration.inHours}:${(duration.inMinutes % 60 ).toString().padLeft(2,'0')}:${(duration.inSeconds % 60 ).toString().padLeft(2,'0')}';
  }

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
      _isBooked = false;
      _parkposition = null;
      modelWLlicense = "";
      _bId=0;
    });
    _animationController = AnimationController(
      duration: Duration(hours: 1),
      vsync: this
    );

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
          Visibility(
            visible: !_isBooked,
            child: Container(
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
                onSearch: (Place place) {
                  setState(() {
                    _pages.clear();
                    _markers.clear();
                    _polyLines.clear();
                  });},
                onSelected: (Place place) async{
                  setState(() {
                    _pages.clear();
                    _markers.clear();
                    _polyLines.clear();
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
                      })).then((result) {
                    if (result.hasException) {
                      print(result.exception.toString());
                    }
                    List<dynamic> parkingSpotsInfo = result.data['searchNear'].toList();
                    parkingSpotsInfo.forEach((element) {
                      LatLng spotLL = new LatLng(element['latitude'], element['longitude']);
                      Map<String, dynamic> _spotInfo = new Map<String, dynamic>();
                      _spotInfo['id'] = element['id'];
                      _spotInfo['latitude'] = element['latitude'];
                      _spotInfo['longitude'] = element['longitude'];
                      _spotInfo['address'] = element['address'];
                      _spotInfo['price'] = element['price'];


                      setState(() {
                        _pages.add(ResultInfoWindow(spotLL,element['address'],element['price'].toString(),_spotInfo));
                        createMarker(spotLL,element['id'].toString(),element['address'],element['price'].toString());
                      });
                    });

                    return;
                  });


                },
              ),
            ),
          ),
          Visibility(
            visible: _isBooked,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child){
                return new Positioned(
                  top:MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
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
                    alignment: Alignment.center,
                    child: Row(
                     children: [
                       Text(modelWLlicense+' ',style: TextStyle(fontSize: 25.0,color: Colors.green)),
                       Text(timerString,style: TextStyle(fontSize: 25.0,color: Colors.blue)),
                     ],
                    )
                  ),
                );
              },
            )
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            bottom: (_pages.length>0)?0:-50,
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
                    onPressed: () => _orderDialog(context,_parkposition, (orderedSpots) {
                      setState(() {
                        _markers.clear();
                        _pages.clear();
                        LatLng spotLL = new LatLng(orderedSpots['latitude'], orderedSpots['longitude']);
                        createMarker(spotLL, orderedSpots['id'].toString(), orderedSpots['address'],orderedSpots['price'].toString());
                        _isOrderVisible = false;
                        _drawPolyline(spotLL);
                        _isBooked = true;
                        _animationController.duration = Duration(hours: orderedSpots['duration']);
                        modelWLlicense = orderedSpots['modelWLlicense'];
                        _bId = orderedSpots['bid'];
                      });
                      _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);

                    }),

                    label: Text("Order"),
                    backgroundColor: Colors.green,
                  ),
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
                visible: _isBooked,
                child: Container(
                  height: 45,
                  padding: EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.stop),
                    onPressed: () async {
                      final GraphQLClient _client =
                      graphQLConfiguration.clientToQuery();
                      final QueryResult r = await _client.query(QueryOptions(
                          documentNode: gql(deleteOrder),
                          variables: <String, dynamic>{
                            'id':_bId,
                          })).then((result) {
                        if (result.hasException) {
                          print(result.exception.toString());
                        }
                        return;
                      });

                      setState(() {
                        _isBooked = false;
                        _animationController.stop();
                        _animationController.reset();
                        _markers.clear();
                        _polyLines.clear();
                        _parkposition.clear();
                        modelWLlicense="";
                        _bId = 0;
                      });

                    },
                    label: Text("stop"),
                    backgroundColor: Colors.red,
                  ),
                )
            ),
          ),
        ],
      )



    );

  }

  void _orderDialog(context, parkPositionInfo, updateParentStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        orderDialog orderWindow = new orderDialog(
          parkPositionInfo: parkPositionInfo,
          updateParentStatus: updateParentStatus,
        );
        return orderWindow;
      },
    );
  }


  void createMarker(LatLng position, String id, String address, String price ){
    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(
        title: address,
        snippet: '\$'+price,
      ),

    );
    _markers[id] = marker;
  }



  Widget ResultInfoWindow(LatLng destination, String name, String price, Map<String, dynamic> spotelement){
    return GestureDetector(
      onTap: () {
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination, zoom: 15,tilt: 50.0,
          bearing: 45.0,)));
        setState(() {
          _isOrderVisible = true;
          _parkposition = spotelement;
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


  Future<void> _drawPolyline(LatLng destination) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 13.5,tilt: 50.0,
      bearing: 45.0,)));
    String route = await _googleMapsServices.getRouteCoordinates(sourceLoc, destination);
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId('navi'),
          width: 4,
          points: _convertToLatLng(_decodePoly(route)),
          color: Colors.red));
    });
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
}

