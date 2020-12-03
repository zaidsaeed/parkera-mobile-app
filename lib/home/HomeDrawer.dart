import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:parkera/CarInfo/listUserCars.dart';
import 'package:parkera/addParkingSpot/listParkingSpot.dart';
import 'package:parkera/main.dart';
import 'package:parkera/globals.dart' as globals;


class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('My Action'),
            decoration: BoxDecoration(
              color: Colors.teal,
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
            title: Text('Show all My park spots'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => listParkingSpots()),
              );
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: (){
              globals.userid == null;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (Route route) => false);
            },
          ),
        ],
      ),
    );
  }
}
