import 'package:flutter/material.dart';
import 'package:flutter_demo1/transitions/enter_exit_route.dart';
import 'package:flutter_demo1/transitions/scale_rotate_route.dart';

import 'fade_screen.dart';

class RandomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('EnterExitSlideTransition'),
              onPressed: () =>
                  Navigator.push(context, EnterExitRoute(this, Screen2())),
            ),
            RaisedButton(
              child: Text('ScaleRotateTransition'),
              onPressed: () =>
                  Navigator.push(context, ScaleRotateRoute(Screen2())),
            ),
          ],
        ),
      ),
    );
  }
}
