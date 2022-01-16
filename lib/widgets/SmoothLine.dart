import 'dart:math';
import 'package:flutter/material.dart';

enum MovingLevel {
  SPPED_QUICK,
  SPEED_SLOWLY,
}

class MyCustomPaint extends StatefulWidget {
  final Function(int)? percentCallback;

  MyCustomPaint({Key? key, this.percentCallback}) : super(key: key);

  final _myCustomPaint = _MyCustomPaint();

  void start(MovingLevel level) {
    _myCustomPaint.start(level);
  }

  void stop() {
    _myCustomPaint.stop();
  }

  @override
  State<StatefulWidget> createState() => _myCustomPaint;
}

//速度... 的快慢
class _MyCustomPaint extends State<MyCustomPaint>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  int _percent = 0;

  //默认 是停止状态...
  bool isPaused = true;

  //皇冠有啥的哦, 好的吧, 就是的呢?  你说是就是吧, 哎,是的吧, 好的吧, 有戏的啊.
  void start(MovingLevel speedLevel) {
    if (!isPaused) {
      return; //如果还没有停止... 那么就不执行...
    }
    isPaused = false;
    print('------------------>start');
    int leftMilliSeconds;
    switch (speedLevel) {
      case MovingLevel.SPPED_QUICK:
        //20000.0 ~/ 100  表示 每一个百分比 所花的时间..
        leftMilliSeconds = (100 - _percent) * 2000.0 ~/ 100;
        break;
      case MovingLevel.SPEED_SLOWLY:
        leftMilliSeconds = (100 - _percent) * 20000.0 ~/ 100;
        break;
    }
    _animationController = AnimationController(
        duration: Duration(milliseconds: leftMilliSeconds), vsync: this);
    //从当前的 百分数进度开始..
    _animation = Tween<double>(begin: _percent.toDouble(), end: 100)
        .animate(_animationController)
      ..addListener(() {
        int value = _animation.value.toInt();
        if (_percent != value) {
          setState(() {
            // The state that has changed here is the animation object’s value.
            _percent = value;
            //回调当前的百分比...
            Future(() => widget.percentCallback?.call(_percent));
          });
        }
      });
    _animationController.forward();
  }

  void stop() {
    if (isPaused) {
      return;
    }
    print('------------------>stop');
    isPaused = true;
    _animationController.stop(canceled: true);
    _animationController.dispose();
  }

  void reset([MovingLevel movingLevel = MovingLevel.SPEED_SLOWLY]) {
    stop();
    start(movingLevel);
  }

  @override
  void initState() {
    super.initState();
    start(MovingLevel.SPEED_SLOWLY); //默认一开始是慢速 动画...
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        SizedBox(
          height: 0,
          child: Text(_percent.toString()), //不用一个 组件来渲染, 进度条不显示,  这是啥原因...
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: CustomPaint(
              painter: SmoothLine(_percent),
            ),
          ),
        ),
      ],
    );
  }
}

class SmoothLine extends CustomPainter {
  final fillColors = [Colors.blue.shade50, Colors.blue.shade800];
  Paint painter = Paint()
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  List<Point> points = [];
  late double y0;

  final int percent;

  SmoothLine(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    _initPoints(size);
    Path path = _initPath(size, points);
    _drawLine(canvas, size, path);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _initPoints(Size size) {
    if (points.isNotEmpty) {
      return;
    }
    y0 = size.height / 2;
    points = initPoints(size, y0);
  }

  _initPath(Size size, List<Point> points) {
    var path = Path();
    double preX, //前一个数据的 x 值
        preY, //前一个数据的 y 值
        currentX,
        currentY;
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        double key = 0; //第一个数的x值
        // chartBeans[i].y / maxMin[0] 算出当前y值为最大的值得百分比 * 表高 得出具体所对应的Y轴值
        //用 startY - y值  可以得到最终在屏幕上的y值
        var value = points[i].y.toDouble();
        //移动到对应数据的位置
        path.moveTo(key, value);
        continue;
      }
      //绘制完第一个点后，向右平移一个 宽度（w）
      currentX = points[i].x.toDouble();
      //前一个数据的 x 值
      preX = points[i - 1].x.toDouble();
      //前一个数据的y值
      preY = points[i - 1].y.toDouble();
      currentY = points[i].y.toDouble();

      //绘制贝塞尔路径  （可以本站搜索或者百度，有很详尽的介绍）
      path.cubicTo(
          (preX + currentX) / 2,
          preY, // control point 1
          (preX + currentX) / 2,
          currentY, //  control point 2
          currentX,
          currentY);
    }
    return path;
  }

  double _getXFromPercent(Size size, int percent) {
    return size.width / 100 * percent;
  }

  initPoints(Size size, double y0) {
    var points = <Point>[];
    for (int i = 0; i <= 100; i = i + 10) {
      if (i <= 30) {
        points.add(Point(_getXFromPercent(size, i), y0));
      } else if (i <= 40) {
        points.add(Point(
            _getXFromPercent(size, i), y0 - (size.height / 4 / 10) * (i - 30)));
      } else if (i <= 60) {
        if (i == 50) {
          continue;
        }
        points.add(Point(_getXFromPercent(size, i),
            y0 - size.height / 4 + (size.height / 2 / 20) * (i - 40)));
      } else if (i <= 70) {
        points.add(Point(_getXFromPercent(size, i),
            y0 + size.height / 4 - (size.height / 4 / 10) * (i - 60)));
      } else {
        points.add(Point(_getXFromPercent(size, i), y0));
      }
    }
    return points;
  }

  _drawLine(Canvas canvas, Size size, Path path) {
    var paintFull = Paint()
      ..isAntiAlias = true //抗锯齿
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round //这个是画笔结束后的样式：这里是圆形
      ..color = Colors.blueAccent.shade100
      ..style = PaintingStyle.stroke;

    var paint2 = Paint()
      ..isAntiAlias = true //抗锯齿
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round //这个是画笔结束后的样式：这里是圆形
      ..color = Colors.blueAccent.shade400
      ..style = PaintingStyle.stroke;

    ///安卓原生端 可以根据PathMeasure 得到路径每个点的坐标
    ///flutter 是通过computeMetrics ，作用基本是一致的.
    var pathMetrics = path.computeMetrics(forceClosed: false); //第二个参数是否要连接起点
    ///生成的list，每个元素代表一条path生成的Metrics，(咱们这里只有一个path，所以元素只有一个)
    var list = pathMetrics.toList();
    Path linePathFull = Path();
    Path linePathReal = Path();
    //填充颜色区域
    for (int i = 0; i < list.length; i++) {
      //开始抽取位置
      double startExtr = 0;
      //结束抽取位置
      double endExtr = list[i].length * percent / 100;
      var extractPath =
          list[i].extractPath(startExtr, endExtr, startWithMoveTo: true);
      var fullPath =
          list[i].extractPath(startExtr, list[i].length, startWithMoveTo: true);

      linePathFull.addPath(fullPath, const Offset(0, 0));
      linePathReal.addPath(extractPath, const Offset(0, 0));
    }
    canvas.drawPath(linePathFull, paintFull);
    canvas.drawPath(linePathReal, paint2);
  }
}
