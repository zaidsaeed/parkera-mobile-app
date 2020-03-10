import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'addParkingSpot/addParkingSpotDialogWindow.dart';
import 'addCar/addCarInfoAlertDialogWindow.dart';
import 'package:toast/toast.dart';
import 'package:parkera/CarInfo/addCarInfoAlertDialogWindow.dart';
import 'package:parkera/CarInfo/listUserCars.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  GoogleMapController mapController;

  final LatLng _center = LatLng(45.425533, -75.692482);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final String snackbarText;
  Home({this.snackbarText});
  void _addParkingSpot(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow = new AlertDialogWindow();
        return alertDialogWindow;
      },
    );
  }

  void _addCarInfo(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        carInfoAlertDialog carInalertDialogWindow = new carInfoAlertDialog();
        return carInalertDialogWindow;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (this.snackbarText != null) {
        Toast.show(this.snackbarText, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button',
            style: TextStyle(fontFamily: 'Lato')),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addParkingSpot(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('My Action'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Show all My cars'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => listUserCars()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
