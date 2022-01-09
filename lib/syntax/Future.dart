import 'Mixin.dart';

void main() {
  future('hello !!').then((r) => log(r), onError: (error) {});
  f3();
  f4();
  f5();
}

future(Object o) => Future(() {
      log(o);
      return 1;
    });

var f = Future(() {
  return "hello !!!";
});
var f1 = Future(f2);

f2() {
  return "1";
}

f3() async {
  await log('f3');
}

f4() async {
  log('f4');
}

f5() {
  log('f5');
}

var l = ['', '2', 3];
var l2 = List.empty(); //数组或者 list
var map = {"name": "2", "key": 2}; // map
