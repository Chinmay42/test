
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
//import 'package:oesapp/src/features/formbuilder/domain/entities/formbuilder_entities.dart';

class FormBuilderModel extends FormBuilderListentities {
  FormBuilderModel(
      {@required String inputtextfield,
      @required bool input,
      @required bool tableView,
      @required String inputType,
      @required String inputMask,
      @required String label,
      @required String key,
      @required String placeholder,
      @required String prefix,
      @required String suffix,
      @required bool multiple,
      @required String defaultValue,
      @required bool protected,
      @required bool unique,
      @required bool persistent,
      @required String type,
      @required String hashKey,
      @required bool autofocus,
      @required bool hidden,
      @required bool clearOnHide,
      @required bool spellcheck,
      @required String theme,
      @required bool disableOnInvalid,
      @required String action,
      @required bool block,
      @required String rightIcon,
      @required String leftIcon,
      @required String size,
      @required Validate validate,
      @required Conditional conditional})
      : super(
          inputtextfield: inputtextfield,
          input: input,
          tableView: tableView,
          inputType: inputType,
          inputMask: inputMask,
          label: label,
          key: key,
          placeholder: placeholder,
          prefix: prefix,
          suffix: suffix,
          multiple: multiple,
          defaultValue: defaultValue,
          protected: protected,
          unique: unique,
          persistent: persistent,
          type: type,
          hashKey: hashKey,
          autofocus: autofocus,
          hidden: hidden,
          clearOnHide: clearOnHide,
          spellcheck: spellcheck,
          theme: theme,
          disableOnInvalid: disableOnInvalid,
          action: action,
          block: block,
          rightIcon: rightIcon,
          leftIcon: leftIcon,
          size: size,
          validate: validate,
          conditional: conditional,
        );

  factory FormBuilderModel.fromJson(Map<String, dynamic> json) {
    return FormBuilderModel(
        inputtextfield:
            json['inputtextfield'] != null ? json['inputtextfield'] : null,
        input: json['input'],
        tableView: json['tableView'],
        inputType: json['inputType'] != null ? json['inputType'] : null,
        inputMask: json['inputMask'] != null ? json['inputMask'] : null,
        label: json['label'],
        key: json['key'],
        placeholder: json['placeholder'] != null ? json['placeholder'] : null,
        prefix: json['prefix'] != null ? json['prefix'] : null,
        suffix: json['suffix'] != null ? json['suffix'] : null,
        multiple: json['multiple'] != null ? json['multiple'] : null,
        defaultValue:
            json['defaultValue'] != null ? json['defaultValue'] : null,
        protected: json['protected'] != null ? json['protected'] : null,
        unique: json['unique'] != null ? json['unique'] : null,
        persistent: json['persistent'] != null ? json['persistent'] : null,
        type: json['type'],
        hashKey: json['hashKey'],
        autofocus: json['autofocus'],
        hidden: json['hidden'] != null ? json['hidden'] : null,
        clearOnHide: json['clearOnHide'] != null ? json['clearOnHide'] : null,
        spellcheck: json['spellcheck'] != null ? json['spellcheck'] : null,
        theme: json['theme'] != null ? json['theme'] : null,
        disableOnInvalid:
            json['disableOnInvalid'] != null ? json['disableOnInvalid'] : null,
        action: json['action'] != null ? json['action'] : null,
        block: json['block'] != null ? json['block'] : null,
        rightIcon: json['rightIcon'] != null ? json['rightIcon'] : null,
        leftIcon: json['leftIcon'] != null ? json['leftIcon'] : null,
        size: json['size'] != null ? json['size'] : null,
        validate: json['validate'] != null
            ? ValidateModel.fromJason(json['validate'])
            : null,
        conditional: json['conditional'] != null
            ? ConditionalModel.fromJason(json['conditional'])
            : null);
  }
}

class ValidateModel extends Validate {
  ValidateModel(
      {@required bool required,
      @required String minLength,
      @required String maxLength,
      @required String pattern,
      @required String custom,
      @required bool customPrivate})
      : super(
          required: required,
          minLength: minLength,
          maxLength: maxLength,
          pattern: pattern,
          custom: custom,
          customPrivate: customPrivate,
        );
  factory ValidateModel.fromJason(Map<String, dynamic> json) {
    return ValidateModel(
        required: json['required'],
        minLength: json['minLength'],
        maxLength: json['maxLength'],
        pattern: json['pattern'],
        custom: json['custom'],
        customPrivate: json['customPrivate']);
  }
}

class ConditionalModel extends Conditional {
  ConditionalModel(
      {@required bool show, @required String when, @required String eq})
      : super(
          show: show,
          when: when,
          eq: eq,
        );
  factory ConditionalModel.fromJason(Map<String, dynamic> json) {
    return ConditionalModel(
        show: json['show'], when: json['when'], eq: json['eq']);
  }
}
