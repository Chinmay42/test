import 'package:dartz/dartz.dart';

import 'package:fabric_mobile/client/mobile/src/core/errors/failure.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';


abstract class FormBuilderRepositiry {
  Future<Either<Failure, List<FormBuilderListentities>>> getdata(
      String examtype);
}
