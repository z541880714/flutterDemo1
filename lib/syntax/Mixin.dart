typedef ToString = String Function();

ToString getToString(Object x) => x.toString;

log(Object o) => print(o);

mixin Run {}

mixin Fly {}

abstract class A1 {
  void a();
}

class A2 {
  void a() {}
}

void main() {
  print("hello !");
  test1();
}

//with 是 dart  引用 minxin 的一个机制..
class A3 with A1, A2 {}

class S {
  fun() {
    log("A");
  }
}

mixin MA {
  fun() {
    log("MA");
    log("MAA");
  }
}

mixin MB on S {
  fun() {
    log("start !!");
    super.fun();
    log("MB");
  }
}

class MC {
  fun() {
    log("MC");
  }
}

class A extends S with MA, MB {}

class B extends S with MB, MA {}

class C extends S with MB, MA, MC {}

void test1() {
  var a = A();
  a.fun();
}

abstract class AA {
  void a();
}

class AA1 implements AA {
  @override
  void a() {
    // TODO: implement a
  }
}
