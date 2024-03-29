import 'dart:math';

import 'package:flutter/material.dart';

class RotateIconCounterfoil extends StatefulWidget {
  final Widget child;
  final Function onTap;
  const RotateIconCounterfoil({Key key, this.child, this.onTap}) : super(key: key);
  @override
  _RotateIconCounterfoilState createState() => _RotateIconCounterfoilState();
}

class _RotateIconCounterfoilState extends State<RotateIconCounterfoil>
    with SingleTickerProviderStateMixin {
  Animation rotate;
  AnimationController controller;
  double angle = 0.0;
  bool clicked = false;

  void initAnimation() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    rotate = Tween(begin: angle, end: pi).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceOut));
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
    return AnimatedBuilder(
        animation: controller,
        builder: (context, snapshot) {
          return Transform.rotate(
            angle: rotate.value,
            child: GestureDetector(
                onTap: () {
                  widget.onTap();
                  if (!clicked) {
                    clicked = true;
                    controller.forward();
                  } else {
                    clicked = false;
                    controller.reverse();
                  }
                },
                child: widget.child),
          );
        });
  }
}
