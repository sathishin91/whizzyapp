import 'dart:io';

import 'package:dartz/dartz.dart';

import '../constants/api_constants.dart';
import '../core/api_client.dart';
import '../core/app_error.dart';
import '../models/custom_response_model.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository(this._apiClient);

  Future<Either<AppError, CustomResponse>> generateDropdownList() async {
    try {
      final response = await _apiClient.postMethod(
        ApiConstants.areaListDropdown,
        params: {
          "token": "",
        },
      );
      CustomResponse customResponse = customResponseFromJson(response);
      return Right(customResponse);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }
}
