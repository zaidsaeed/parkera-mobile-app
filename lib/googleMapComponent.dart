import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:location/location.dart';
import 'package:parkera/googleMapsServices.dart';
import 'package:search_map_place/search_map_place.dart';

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
  googleMapsServices _googleMapsServices = googleMapsServices();

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
    currentLocation = await location.getLocation();

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

  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    LatLng sourceLoc = LatLng(currentLocation.latitude, currentLocation.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
    setState((){
      _markers.clear();
        var destination =LatLng(45.4231,-75.6831);
        final marker = Marker(
          markerId: MarkerId('uottawa'),
          position: destination,
          infoWindow: InfoWindow(
            title: 'uottawa',
            snippet: '75 Laurier Ave E, Ottawa, ON K1N 6N5',
            onTap: () {
              _gotoLocation(destination.latitude,destination.longitude);
            },
          ),

        );
        _markers['uottawa'] = marker;
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
                Geolocation geolocation = await place.geolocation;
                mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          )

        ],
      )



    );

  }

  Future<void> _gotoLocation(double lat,double long) async {
    LatLng sourceLoc = LatLng(currentLocation.latitude, currentLocation.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: sourceLoc, zoom: 15,tilt: 50.0,
      bearing: 45.0,)));

}
}

