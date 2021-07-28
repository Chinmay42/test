import 'package:dartz/dartz.dart';
import 'package:fabric_mobile/client/mobile/src/core/errors/exception.dart';
import 'package:fabric_mobile/client/mobile/src/core/errors/failure.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/data/datasources/dashboard_datasource.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/entities/dashboard_entities.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/repositories/dashboard_repository.dart';

import 'package:flutter/material.dart';


class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({@required this.remoteDataSource});

  final DashboardDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<DashboardItem>>> getdata(String userid) async {
    try {
      final data = await remoteDataSource.getdata(userid);

      return Right(data);
    } on APIException {
      return Left(APIFailure(message: 'Api Error'));
    }
  }
}
