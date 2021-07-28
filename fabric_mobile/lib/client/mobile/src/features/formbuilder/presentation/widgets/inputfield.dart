
import 'package:fabric_mobile/client/mobile/config/AppConfig.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/formvalidator.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';
import 'package:flutter/material.dart';


Widget createinputfield(
    Map<String, String> output,
    String inputtype,
    BuildContext context,
    String inputlable,
    String inputplaceholder,
    String inputname,
    Validate validator) {
  SizeConfig().init(context);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: SizeConfig.screenWidth * 90,
      child: TextFormField(
        style: Theme.of(context).textTheme.subtitle,
        keyboardType: _getkeybordtype(inputtype),
        maxLines: _getmaxline(inputtype),
        enableInteractiveSelection: false,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {},
        decoration: InputDecoration(
            fillColor: LightColors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelText: inputlable,
            hintText: inputplaceholder),
        validator: (value) {
          return validators(inputtype, value, validator, inputlable);
        },
        onChanged: (text) {
          output[inputname] = text;
        },
        onSaved: (String value) {},
      ),
    ),
  );
}

TextInputType _getkeybordtype(String type) {
  switch (type) {
    case "text":
      return TextInputType.text;
    case "email":
      return TextInputType.emailAddress;
    case "mobile":
      return TextInputType.phone;
    case "textarea":
      return TextInputType.multiline;
    default:
      return TextInputType.text;
  }
}

int _getmaxline(String type) {
  print("type");
  print(type);
  switch (type) {
    case "textarea":
      return 10;
    default:
      return null;
  }
}
