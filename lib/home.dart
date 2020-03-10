import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'addParkingSpot/addParkingSpotDialogWindow.dart';
import 'addCar/addCarInfoAlertDialogWindow.dart';
import 'package:toast/toast.dart';

class Home extends StatelessWidget {

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
        backgroundColor: Color(0xFF00897B),
      ),
      body: Center(
          child: Column(children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .02),
        OutlineButton(
            child: new Text(
              "add a car",
              style: TextStyle(fontFamily: 'Lato'),
            ),
            onPressed: () => _addCarInfo(context),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)))
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addParkingSpot(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('My Action'),
              decoration: BoxDecoration(
                color: Color(0xFF00897B),
              ),
            ),
            ListTile(
              title: Text('Show all My cars'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
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
