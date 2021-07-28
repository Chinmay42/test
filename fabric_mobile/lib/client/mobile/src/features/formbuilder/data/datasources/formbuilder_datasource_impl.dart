import 'dart:convert';

import 'package:fabric_mobile/client/mobile/src/features/formbuilder/data/models/formbuilder_model.dart';
import 'package:flutter/services.dart';

import 'frombuilder_datasource.dart';


class FromBuilderDatasourceimpl implements FromBuilderDatasource {
  FromBuilderDatasourceimpl();
  @override
  Future<List<FormBuilderModel>> getdata(String examtype) async {
    List<FormBuilderModel> list;
    final response = await rootBundle.loadString('assets/form.json');
    print(examtype);
    var data = json.decode(response);
    var rest = data[examtype] as List;
    list = rest
        .map<FormBuilderModel>((json) => FormBuilderModel.fromJson(json))
        .toList();
    return list;
  }
}
