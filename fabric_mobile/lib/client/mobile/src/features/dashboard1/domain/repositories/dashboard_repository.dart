


import 'package:dartz/dartz.dart';
import 'package:fabric_mobile/client/mobile/src/core/errors/failure.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard1/domain/entities/dashboard_entities.dart';



abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardItem>>> getdata(String userid);
}