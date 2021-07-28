//import 'package:oesapp/src/features/formbuilder/domain/entities/formbuilder_entities.dart';

import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';

String validators(
    String type, String value, Validate validator, String inputlable) {
  if (validator.required == true) {
    if (value == "") return inputlable + ' can not be blank';
  }

  if (validator.minLength != "") {
    if (value.length < int.parse(validator.minLength))
      return inputlable +
          ' must be more than ' +
          validator.minLength +
          ' charater';
  }

  if (validator.maxLength != "") {
    if (value.length > int.parse(validator.maxLength))
      return inputlable +
          ' must be less than ' +
          validator.maxLength +
          ' charater';
  }

  if (type == "email") return validateEmail(value);

  if (type == "mobile") return validateMobile(value);

  return null;
}

String validateMobile(String value) {
  if (value.length != 10)
    return 'Mobile number must be of 10 digit';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter valid email';
  else
    return null;
}
