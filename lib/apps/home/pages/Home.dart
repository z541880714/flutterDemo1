import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo1/message/MEventChannel.dart';
import 'package:flutter_demo1/widgets/SmoothLine.dart';
import 'package:flutter_demo1/widgets/circularPropressIndication.dart';
import 'package:flutter_demo1/widgets/xball_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var messageChannel = const BasicMessageChannel("test", StringCodec());
  var eventChannel = MyEventChannel("event_channel_1");

  @override
  void initState() {
    super.initState();
    messageChannel.setMessageHandler((message) => Future(() {
          // print("message: $message");
          return "";
        }));
    eventChannel.registerEvent((message) => Future(() {
          // print('event channel callback ----------------> $message');
        }));
  }

  @override
  void dispose() {
    super.dispose();
    messageChannel.setMessageHandler(null);
    eventChannel.unregisterEvent();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox.fromSize(
            size: const Size(double.infinity, 200),
            child: MyCustomPaint(
              percentCallback: (percent) {
                print('percent: $percent');
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.fromSize(
                size: const Size(20, 20),
                child: const CircularProgress(),
              ),
              const XBallView(size: Size(30, 30))
            ],
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Text('点我'),
        onPressed: () {
          // _incrementCounter();
          // Navigator.push(context, RotationRoute(FadeScreen()));
          Navigator.pushNamed(context, '/second');
        },
      ),
    );
  }
}
