
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/presentation/widgets/buttonfield.dart';
import 'package:flutter/material.dart';

import 'inputfield.dart';


class FormBuilderList extends StatelessWidget {
  List<FormBuilderListentities> frombuilder;
  GlobalKey<FormState> formKey;
  bool autoValidate;
  FormBuilderList({
    @required this.frombuilder,
    @required this.formKey,
    @required this.autoValidate,
  });

  Map<String, String> output = Map<String, String>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = frombuilder[index];
          output[data.key] = "";
          if (data.inputtextfield == "text") {
            return createinputfield(output, data.inputType, context, data.label,
                data.placeholder, data.key, data.validate);
          }
          if (data.type == "button") {
            return createbuttonfield(
                context, data.label, formKey, autoValidate, output);
          }
        },
        shrinkWrap: true,
        itemCount: frombuilder.length);
  }
}
