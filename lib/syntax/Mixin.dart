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

//on的用法, MB 为S 类的子类..  只有 S 的 子类 才能 混入 MB ,
// MB 实现的方法 是作用在S 类上 是 S 类的扩展... 所以 所有的  S 子类可以 混入, 其他类不能混入. .
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

//D 为 S 的子类, 可以混入MB
class D extends A with MB {}

/// E 不是 S 的子类, 不能混入 MB
// class E with MB {}

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
