import 'package:flutter/material.dart';
import 'package:flutter_demo1/transitions/rotation_route.dart';

import 'fade_screen.dart';

class RotationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: RaisedButton(
          child: Text('RotationTansition'),
          onPressed: () => Navigator.push(context, RotationRoute(Screen2())),
        ),
      ),
    );
  }
}
