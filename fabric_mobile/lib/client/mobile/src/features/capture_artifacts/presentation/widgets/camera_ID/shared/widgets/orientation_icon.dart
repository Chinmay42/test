import 'dart:math';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class OrientationWidgetID extends StatefulWidget {
  final Widget child;
  final NativeDeviceOrientation orientation;

  const OrientationWidgetID(
      {Key key, @required this.child, @required this.orientation})
      : super(key: key);
  @override
  _OrientationWidgetIDState createState() => _OrientationWidgetIDState();
}

class _OrientationWidgetIDState extends State<OrientationWidgetID>
    with SingleTickerProviderStateMixin {
  Animation rotate;
  AnimationController controller;
  double angle = 0.0;
  NativeDeviceOrientation orientation;

  void initAnimation() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    rotate = Tween(begin: angle, end: angle)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
  }

  @override
  void initState() {
    initAnimation();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    orientation = widget.orientation;

    if (orientation == NativeDeviceOrientation.portraitDown ||
        orientation == NativeDeviceOrientation.portraitUp) {
      if (controller.isCompleted) controller.reverse();
      return AnimatedBuilder(
          animation: controller,
          builder: (context, snapshot) {
            return Transform.rotate(
              angle: rotate.value,
              child: widget.child,
            );
          });
    } else {
      if (orientation == NativeDeviceOrientation.landscapeLeft) {
        controller.reset();
        rotate = Tween(begin: angle, end: pi / 2).animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceOut));
        controller.forward();
        return AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {
              return Transform.rotate(
                angle: rotate.value,
                child: widget.child,
              );
            });
      } else if (orientation == NativeDeviceOrientation.landscapeRight) {
        controller.reset();
        rotate = Tween(begin: angle, end: -pi / 2).animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceOut));
        controller.forward();
        return AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {
              return Transform.rotate(
                angle: rotate.value,
                child: widget.child,
              );
            });
      } else {
        return widget.child;
      }
    }
  }
}
