import 'package:flutter/services.dart';

class MyEventChannel {
  MyEventChannel(this.name) : eventChannel = EventChannel(name);

  final String name;

  final EventChannel eventChannel;

  void registerEventBroadcast() {
    print('register evnet broadcast');
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object? event) {
    print('onEvent: $event');
  }

  void _onError(Object? error) {
    print('onError: $error');
  }
}
