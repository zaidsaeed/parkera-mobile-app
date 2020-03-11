import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:parkera/addParkingSpot/addParkingSpotDialogWindow.dart';
import 'package:parkera/CarInfo/addCarInfoAlertDialogWindow.dart';

class HomeSpeedDial extends StatelessWidget {
  const HomeSpeedDial({Key key}) : super(key: key);

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
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              animatedIconTheme: IconThemeData(size: 22),
              backgroundColor: Colors.blueAccent,
              visible: true,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.directions_car),
                    backgroundColor: Colors.blueAccent,
                    onTap: () => _addCarInfo(context),
                    label: 'Add Car',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: Colors.blueAccent),
                // FAB 2
                SpeedDialChild(
                    child: Icon(Icons.local_parking),
                    backgroundColor: Colors.blueAccent,
                    onTap: () => _addParkingSpot(context),
                    label: 'Add Parking Spot',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0),
                    labelBackgroundColor: Colors.blueAccent)
              ],
            )));
  }
}
