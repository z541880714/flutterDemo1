import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CircularProgressState extends State<CircularProgress>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 5,
      semanticsLabel: 'Linear progress indicator',
    );
  }
}
