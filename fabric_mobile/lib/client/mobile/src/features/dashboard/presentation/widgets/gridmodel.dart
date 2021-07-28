import 'package:flutter/material.dart';

class GridModel {
  IconData _icon;
  String _title;
  Color _color;

  GridModel(this._icon, this._title, this._color);

  IconData get icons => _icon;

  set icon(Icon value){
    _icon = icons;
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

/*  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }
*/

}