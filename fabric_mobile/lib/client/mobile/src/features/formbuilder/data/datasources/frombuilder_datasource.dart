
//import 'package:oesapp/src/features/formbuilder/data/models/formbuilder_model.dart';

import 'package:fabric_mobile/client/mobile/src/features/formbuilder/data/models/formbuilder_model.dart';

abstract class FromBuilderDatasource {
  Future<List<FormBuilderModel>> getdata(String examtype);
}
