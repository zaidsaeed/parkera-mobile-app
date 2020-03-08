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
    if (this.snackbarText != null) {
      Toast.show(this.snackbarText, context,
          duration: 5, gravity: Toast.BOTTOM);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button',
            style: TextStyle(fontFamily: 'Lato')),
      ),
      body: Center(
          child: Column(children: <Widget>[
        const Text('Press the button below!',
            style: TextStyle(fontFamily: 'Lato')),
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
