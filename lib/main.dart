import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'apps/home/mainNavigator.dart' as mainNavigator;

void main() {
  runApp(const MyApp());
  //沉浸式状态栏 ..
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///没一个 MaterialApp  对应一个Navigator
    return MaterialApp(
      title: 'Flutter Demo',
      routes: mainNavigator.mainRoute,
      navigatorObservers: [
        mainNavigator.GLObserver(), // 导航监听
        mainNavigator.routeObserver, // 路由监听
      ],
      home: mainNavigator.mainRoute['/home']?.call(context),
    );
  }
}
