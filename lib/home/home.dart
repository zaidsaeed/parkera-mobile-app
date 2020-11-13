import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkera/home/HomeDrawer.dart';
import 'package:parkera/home/HomeSpeedDial.dart';
import 'package:parkera/googleMapComponent.dart';
import 'package:toast/toast.dart';

class Home extends StatelessWidget {
  final String snackbarText;
  Home({this.snackbarText});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (this.snackbarText != null) {
        Toast.show(this.snackbarText, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              })),
      drawer: HomeDrawer(),
      floatingActionButton: HomeSpeedDial(),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            googleMapComponent(),

        //SizedBox(height: MediaQuery.of(context).size.height * .02),
      ])),
    );
  }
}
