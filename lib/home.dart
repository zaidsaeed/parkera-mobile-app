import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'addParkingSpot/addParkingSpotDialogWindow.dart';
import 'addCar/addCarInfoAlertDialogWindow.dart';


class Home extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button',
        style: TextStyle(
          fontFamily: 'Lato'
        )),
      ),
      body: Center(child: Column( children: <Widget>[
        const Text('Press the button below!',
          style: TextStyle(
            fontFamily: 'Lato'
          )),
        OutlineButton(
            child: new Text("add a car",
            style: TextStyle(
              fontFamily: 'Lato'
            ),),
            onPressed: ()=> _addCarInfo(context),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
        )
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addParkingSpot(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}


