import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

//球半径
int radius = 150;

class XBallView extends StatefulWidget {
  final Size size;

  const XBallView({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _XBallViewState();
  }
}

class _XBallViewState extends State<XBallView>
    with SingleTickerProviderStateMixin {
  late Point _point;

  late Animation<double> animation;
  late AnimationController controller;
  late double currentRadian = 0;

  //上次点击并命中关键词的时间
  int lastHitTime = 0;

  //当前的旋转轴,  旋转的圆形的 法线.. 这个值不要动, 会影响后面的计算..
  //后续如果有 更好的方法或者公式, 再放开...
  final Point axisVector = Point(-1, 1, 0.5);

  //初始点..
  late final Point p0;

  @override
  void initState() {
    super.initState();
    //计算球尺寸、半径等
    radius = (widget.size.width / 2).round();
    //初始化点 以[axisVector] 轴为发现, 与x轴 的夹角 为变量...
    p0 = initPoint(axisVector);
    _point = p0;
    var lastTimeStamp = DateTime.now().millisecondsSinceEpoch;
    //动画
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: pi * 2).animate(controller);
    animation.addListener(() {
      var cur = DateTime.now().millisecondsSinceEpoch;
      if (cur - lastTimeStamp < 15) {
        //控制在 60帧左右...
        return;
      }
      lastTimeStamp = cur;
      _point = rotatePoint(animation.value);
      currentRadian = animation.value;
      pointNotify.value = _point;
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        currentRadian = 0;
        controller.forward(from: 0.0);
      }
    });
    controller.forward();
  }

  @override
  void didUpdateWidget(XBallView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 生成 初始的点, 要求:
  /// 1: 所在的圆 穿过圆心.
  /// 2: 所在的圆 与 [axisVector] 轴线垂直.
  /// 3: 投影到 x,y轴平面 与x轴的夹角为0
  initPoint(Point axisVector) {
    double x = sqrt(radius * radius / 2);
    double y = x;
    double z = 0;
    print(' coordinate: x: $x,  y:$y,  z:$z}');
    //球极坐标转为直角坐标
    return Point(x, y, z);
  }

  late var pointNotify = ValueNotifier(_point);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset(
          "images/ball_big.png",
          width: widget.size.width * 0.7,
          height: widget.size.height * 0.7,
          fit: BoxFit.fill,
        ),
        ValueListenableBuilder<Point>(
            valueListenable: pointNotify,
            builder: (context, point, _) {
              return CustomPaint(
                size: Size(2.0 * radius, 2.0 * radius),
                painter: MyPainter(point),
              );
            })
      ],
    ));
  }

  ///速度跟踪队列
  Queue<PositionWithTime> queue = Queue();

  ///添加跟踪点
  void addToQueue(PositionWithTime p) {
    int lengthOfQueue = 5;
    if (queue.length >= lengthOfQueue) {
      queue.removeFirst();
    }

    queue.add(p);
  }

  ///清空队列
  void clearQueue() {
    queue.clear();
  }

  ///计算速度
  ///速度单位：像素/毫秒
  Offset getVelocity() {
    Offset ret = Offset.zero;

    if (queue.length >= 2) {
      PositionWithTime first = queue.first;
      PositionWithTime last = queue.last;
      ret = Offset(
        (last.position.dx - first.position.dx) / (last.time - first.time),
        (last.position.dy - first.position.dy) / (last.time - first.time),
      );
    }
    return ret;
  }

  Point rotatePoint(double theta) {
    var _theta = theta % (2 * pi);
    var x0 = p0.x;
    var y0 = p0.y;
    var z0 = p0.z; // z0 = 0 计算时已经被忽略掉了.

    double A =
        (radius * radius * (4 * (sin(_theta / 2) * sin(_theta / 2)) - 1) -
                x0 * x0 -
                y0 * y0) /
            (-2 * x0);
    double squart = max((8 * radius * radius - 4 * A * A) / 9, 0);
    double z = sqrt(squart / 3);
    z = theta > pi ? z : (-1 * z);
    double x = (A + z) / 2;
    double y = (A - z) / 2;
    return Point(x, y, z);
  }
}

class MyPainter extends CustomPainter {
  final Point point;
  late Paint ballPaint;

  MyPainter(this.point) {
    ballPaint = Paint()
      ..strokeWidth = point.pointRadius
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('------------------->');
    //绘制球
    Point2D coordinate = transformCoordinate(point);
    //根据当前 z 的距离. 调整point 的大小, 最近->最远 point 大小  7->4
    ballPaint.strokeWidth = (radius + point.z) / (2 * radius) * 3 + 4;
    //最近->最远  颜色值的aplpha 由 1 -> 0.4
    var alpha = (((radius + point.z) / (2 * radius) * 0.8 + 0.2) * 255).round();
    ballPaint.color = Colors.blue.withAlpha(alpha);
    canvas.drawPoints(
        PointMode.points, [ui.Offset(coordinate.x, coordinate.y)], ballPaint);
  }

  ///将3d模型坐标系中的坐标转换为绘图坐标系中的坐标
  ///x2 = r+x1;y2 = r-y1;
  Point2D transformCoordinate(Point point) {
    return Point2D(radius + point.x, radius - point.y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Point2D {
  double x, y;

  Point2D(this.x, this.y);
}

class Point {
  double x, y, z;
  double pointRadius = 5; //当前点的 半径. 即 paint 的线宽, 根据z轴的距离 来调整 大小
  double alpha = 1; //当前的透明度 根据 z 轴的远近 来调整透明度

  Point(this.x, this.y, this.z);

  @override
  String toString() {
    return '--- x: $x,  y: $y';
  }
}

//加载 本地 图片, 转换成image, 使用 canvas 绘制.
//这个保留 ... 以后说不定还用的上
Future<ui.Image> loadingLocalImage(path,
    [int targetWidth = 10, int targetHeight = 10]) async {
  var byteData = await PlatformAssetBundle().load(path);
  Uint8List uint8list = byteData.buffer.asUint8List();
  return instantiateImageCodec(uint8list, targetWidth: 5, targetHeight: 5).then(
      (value) => value.getNextFrame().then((frameInfo) => frameInfo.image));
}

class PositionWithTime {
  Offset position;
  int time;

  PositionWithTime(this.position, this.time);
}
