import 'package:flutter/material.dart';
import 'package:flutter_demo1/transitions/scale_route.dart';

import 'fade_screen.dart';

class ScaleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: RaisedButton(
          child: Text('ScaleTransition'),
          onPressed: () => Navigator.push(context, ScaleRoute(Screen2())),
        ),
      ),
    );
  }
}
