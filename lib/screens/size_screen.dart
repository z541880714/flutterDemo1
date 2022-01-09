import 'package:flutter/material.dart';
import 'package:flutter_demo1/transitions/size_route.dart';

import 'fade_screen.dart';

class SizeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: RaisedButton(
          child: Text('SizeTransition'),
          onPressed: () => Navigator.push(context, SizeRoute(Screen2())),
        ),
      ),
    );
  }
}
