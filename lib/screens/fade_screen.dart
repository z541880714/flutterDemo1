import 'package:flutter/material.dart';
import 'package:flutter_demo1/transitions/fade_route.dart';

class FadeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: RaisedButton(
          child: Text('FadeTansition'),
          onPressed: () => Navigator.push(context, FadeRoute(Screen2())),
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: RaisedButton(
          child: Text('Go Back!'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
