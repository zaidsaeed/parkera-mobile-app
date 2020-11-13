import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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


class _googleMapComponent extends State<googleMapComponent> {
  GoogleMapController mapController;
  Location location;
  LocationData currentLocation;
  double selectedLat;
  double selectedLng;
  bool _isOrderVisible;
  final controller = PageController(
    initialPage: 0,
  );
  googleMapsServices _googleMapsServices = googleMapsServices();

  final pageController = PageController(
    initialPage: 0,
  );

  void setInitialLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    setState(() async {
      currentLocation = await location.getLocation();
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

  GoogleMapController get Mapcontroller =>mapController;



  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Future<void> _onMapCreated(GoogleMapController controller){
    mapController = controller;
    LatLng sourceLoc = LatLng(currentLocation.latitude, currentLocation.longitude);
    /*mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 15,tilt: 50.0,
      bearing: 45.0,)));*/
    setState((){
      _markers.clear();
      var destination =LatLng(45.4231,-75.6831);
      final marker = Marker(
        markerId: MarkerId('uottawa'),
        position: destination,
        infoWindow: InfoWindow(
          title: 'uottawa',
          snippet: '\$7',
        ),

      );
      _markers['uottawa'] = marker;
      var destination1 =LatLng(45.425433, -75.680701);
      final marker1 = Marker(
        markerId: MarkerId('point1'),
        position: destination1,
        infoWindow: InfoWindow(
          title: 'point1',
          snippet: '\$10',
        ),

      );
      _markers['point1'] = marker1;
      var destination2 =LatLng(45.416046, -75.672340);
      final marker2 = Marker(
        markerId: MarkerId('point2'),
        position: destination2,
        infoWindow: InfoWindow(
          title: 'point2',
          snippet: '\$11',
        ),

      );
      _markers['point2'] = marker2;
    });
  }

  @override
  void initState() {
    super.initState();
    location = new Location();
    location.onLocationChanged().listen((LocationData cld) {
      // Use current location
      currentLocation = cld;
    });
    setInitialLocation();
    setState(() {
      _isOrderVisible = false;
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
        children: [
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
        AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        bottom: 0,
        child:Container(
          color: Colors.white.withOpacity(0.8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width*0.7,
                  margin: EdgeInsets.only(top:20,bottom: 20),
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
                      controller: controller,
                    onPageChanged: (int page){
                      setState(() {
                        _isOrderVisible = false;
                      });
                    },
                      children: [
                        GestureDetector(
                          onTap: () {
                            var destination =LatLng(45.4231,-75.6831);
                            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination, zoom: 15,tilt: 50.0,
                              bearing: 45.0,)));
                            setState(() {
                              _isOrderVisible = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text("uottawa",style: TextStyle(fontSize: 25.0,color: Colors.green),)
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text("(\$7)",style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            var destination =LatLng(45.425433, -75.680701);
                            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination, zoom: 15,tilt: 50.0,
                              bearing: 45.0,)));
                            setState(() {
                              _isOrderVisible = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text("point1",style: TextStyle(fontSize: 25.0,color: Colors.green),)
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text("(\$10)",style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            var destination =LatLng(45.416046, -75.672340);
                            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: destination, zoom: 15,tilt: 50.0,
                              bearing: 45.0,)));
                            setState(() {
                              _isOrderVisible = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text("point2",style: TextStyle(fontSize: 25.0,color: Colors.green),)
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text("(\$11)",style: TextStyle(fontSize: 25.0, color: Colors.blueAccent)),
                              ),
                            ],
                          ),
                        ),
                      ],
                  )
              ),
              Visibility(
                  visible: _isOrderVisible,
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.only(bottom: 10),
                    child: FloatingActionButton.extended(
                      icon: Icon(Icons.navigation),
                      label: Text("Order"),
                      backgroundColor: Colors.green,
                    ),
                  )
              ),
            ],
          ),

        ),
      ),

        ],
      )

    );

  }

    void _gotoLocation(double lat,double long) {
    LatLng sourceLoc = LatLng(lat, long);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
    }

}

