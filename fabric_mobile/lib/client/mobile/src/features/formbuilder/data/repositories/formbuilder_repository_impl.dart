import 'package:dartz/dartz.dart';
import 'package:fabric_mobile/client/mobile/src/core/errors/failure.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/data/datasources/frombuilder_datasource.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/entities/formbuilder_entities.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/domain/repositories/formbuilder_repository.dart';
import 'package:flutter/cupertino.dart';


class FromBuilderRepositoryImpl implements FormBuilderRepositiry {
  final FromBuilderDatasource fromBuilderDatasource;

  FromBuilderRepositoryImpl({@required this.fromBuilderDatasource});

  @override
  Future<Either<Failure, List<FormBuilderListentities>>> getdata(
      String userid) async {
    try {
      final data = await fromBuilderDatasource.getdata(userid);

      return Right(data);
    } on APIFailure {
      return Left(APIFailure(message: 'Api Error'));
    }
  }
}
