import 'package:flutter/material.dart';

class FormBuilderListentities {
  final String inputtextfield;
  final bool input;
  final bool tableView;
  final String inputType;
  final String inputMask;
  final String label;
  final String key;
  final String placeholder;
  final String prefix;
  final String suffix;
  final bool multiple;
  final String defaultValue;
  final bool protected;
  final bool unique;
  final bool persistent;
  final String type;
  final String hashKey;
  final bool autofocus;
  final bool hidden;
  final bool clearOnHide;
  final bool spellcheck;
  final String theme;
  final bool disableOnInvalid;
  final String action;
  final bool block;
  final String rightIcon;
  final String leftIcon;
  final String size;

  final Validate validate;
  final Conditional conditional;

  FormBuilderListentities(
      {@required this.inputtextfield,
      @required this.input,
      @required this.tableView,
      @required this.inputType,
      @required this.inputMask,
      @required this.label,
      @required this.key,
      @required this.placeholder,
      @required this.prefix,
      @required this.suffix,
      @required this.multiple,
      @required this.defaultValue,
      @required this.protected,
      @required this.unique,
      @required this.persistent,
      @required this.type,
      @required this.hashKey,
      @required this.autofocus,
      @required this.hidden,
      @required this.clearOnHide,
      @required this.spellcheck,
      @required this.theme,
      @required this.disableOnInvalid,
      @required this.action,
      @required this.block,
      @required this.rightIcon,
      @required this.leftIcon,
      @required this.size,
      @required this.validate,
      @required this.conditional});
}

class Validate {
  final bool required;
  final String minLength;
  final String maxLength;
  final String pattern;
  final String custom;
  final bool customPrivate;

  Validate(
      {this.required,
      this.minLength,
      this.maxLength,
      this.pattern,
      this.custom,
      this.customPrivate});
}

class Conditional {
  final bool show;
  final String when;
  final String eq;
  Conditional({@required this.show, @required this.when, @required this.eq});
}
