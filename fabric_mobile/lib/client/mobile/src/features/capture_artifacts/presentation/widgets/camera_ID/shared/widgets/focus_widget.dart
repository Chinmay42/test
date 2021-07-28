import 'package:flutter/material.dart';

class CameraFocusID {
  CameraFocusID._();

  static Widget rectangle({Color color}) => _FocusRectangleID(color: color);
  static Widget circle({Color color}) => _FocusCircleID(
        color: color,
      );
  static Widget square({Color color}) => _FocusSquareID(
        color: color,
      );
}

class _FocusSquareID extends StatelessWidget {
  final Color color;

  const _FocusSquareID({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: color,
        ),
        clipper: _SquareModePhotoID(),
      ),
    );
  }
}

class _SquareModePhotoID extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var reactPath = Path();

    reactPath.moveTo(size.width / 4, size.height * 2 / 6);
    reactPath.lineTo(size.width * 3 / 4, size.height * 2 / 6);
    reactPath.lineTo(size.width * 3 / 4, size.height * 4 / 6);
    reactPath.lineTo(size.width / 4, size.height * 4 / 6);

    path.addPath(reactPath, Offset(0, 0));
    path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
/*
    path.moveTo(size.width/4, size.height/4);
    path.lineTo(size.width/4, size.height*3/4);
    path.lineTo(size.width*3/4, size.height*3/4);
    path.lineTo(size.width*3/4, size.height/4);
*/
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _FocusRectangleID extends StatelessWidget {
  final Color color;

  const _FocusRectangleID({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: color,
        ),
        clipper: _RectangleModePhotoID(),
      ),
    );
  }
}

class _RectangleModePhotoID extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var reactPath = Path();

    reactPath.moveTo(size.width / 4, size.height / 4);
    reactPath.lineTo(size.width / 4, size.height * 3 / 4);
    reactPath.lineTo(size.width * 3 / 4, size.height * 3 / 4);
    reactPath.lineTo(size.width * 3 / 4, size.height / 4);

    path.addPath(reactPath, Offset(0, 0));
    path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
/*
    path.moveTo(size.width/4, size.height/4);
    path.lineTo(size.width/4, size.height*3/4);
    path.lineTo(size.width*3/4, size.height*3/4);
    path.lineTo(size.width*3/4, size.height/4);
*/
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _FocusCircleID extends StatelessWidget {
  final Color color;

  const _FocusCircleID({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: color,
        ),
        clipper: _CircleModePhoto(),
      ),
    );
  }
}

class _CircleModePhoto extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.4))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
