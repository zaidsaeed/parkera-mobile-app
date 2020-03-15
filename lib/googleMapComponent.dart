import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


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
  LatLng _center;
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
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {
      _markers.clear();

        final marker = Marker(
          markerId: MarkerId('uottawa'),
          position: LatLng(45.4231,-75.6831),
          infoWindow: InfoWindow(
            title: 'uottawa',
            snippet: ' 75 Laurier Ave E, Ottawa, ON K1N 6N5',
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
      print(currentLocation.latitude);
      print(currentLocation.longitude);
    });
    setInitialLocation();
  }



  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: initialCameraPosition,

      ),
    );

  }
}