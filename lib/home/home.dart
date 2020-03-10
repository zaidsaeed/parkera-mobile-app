import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:parkera/home/HomeDrawer.dart';
import 'package:parkera/home/HomeSpeedDial.dart';

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
      appBar: AppBar(
        title: const Text('Floating Action Button',
            style: TextStyle(fontFamily: 'Lato')),
      ),
      drawer: HomeDrawer(),
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[HomeSpeedDial()])),
    );
  }
}
