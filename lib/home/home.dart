import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:parkera/home/HomeDrawer.dart';
import 'package:parkera/home/HomeSpeedDial.dart';
import 'package:parkera/googleMapComponent.dart';
import 'package:toast/toast.dart';

class Home extends StatelessWidget {
  final String snackbarText;
  Home({this.snackbarText});

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
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new Icon(
            Icons.menu,
            color: Colors.black,
          )),
      drawer: HomeDrawer(),
      floatingActionButton: HomeSpeedDial(),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        googleMapComponent()
        //SizedBox(height: MediaQuery.of(context).size.height * .02),
      ])),
    );
  }
}
