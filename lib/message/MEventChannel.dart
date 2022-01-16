import 'package:flutter/services.dart';

class MyEventChannel {
  final String name;
  final EventChannel eventChannel;
  Future Function(Object s)? _eventCallback;

  MyEventChannel(this.name) : eventChannel = EventChannel(name);

  registerEvent(Future Function(Object? message)? callback) {
    print('register evnet broadcast');
    _eventCallback = callback;
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  unregisterEvent() {
    eventChannel.receiveBroadcastStream().listen(null, onError: null);
  }

  void _onEvent(Object? event) {
    if (event != null) {
      _eventCallback?.call(event);
    }
  }

  void _onError(Object? error) {
    print('onError: $error');
  }
}
