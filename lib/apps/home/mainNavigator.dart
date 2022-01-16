import 'package:flutter/cupertino.dart';
import 'package:flutter_demo1/screens/fade_screen.dart';

import 'pages/Home.dart';

//路由表
Map<String, WidgetBuilder> get mainRoute => {
      '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
      '/second': (context) => Screen2(),
    };

class GLObserver extends NavigatorObserver {
// 添加导航监听后，跳转的时候需要使用Navigator.push路由
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    var previousName = previousRoute == null
        ? 'null'
        : (previousRoute.settings.name ?? 'null');

    print('NavObserverDidPush-Current:' +
        (route.settings.name ?? 'null') +
        '  Previous:' +
        previousName);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    var previousName = previousRoute == null
        ? 'null'
        : (previousRoute.settings.name ?? 'null');

    print('NavObserverDidPop-Current:' +
        (route.settings.name ?? 'null') +
        '  Previous:' +
        previousName);
  }
}

// 全局的路由监听者，可在需要的widget中添加，应该放到一个全局定义的文件中
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
