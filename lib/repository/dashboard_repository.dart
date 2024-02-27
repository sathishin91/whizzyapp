import 'dart:convert';
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

  Future<Either<AppError, CustomResponse>> generateDashboardSensorList(
      String sensorId, String startTime, String endTime) async {
    try {
      final response = await _apiClient.postMethod(
        // "${ApiConstants.dashboardSensorList}5487C344-00CC-4020-9A46-CF249395908D/20231201080000/20231201235959",
        "${ApiConstants.dashboardSensorList}$sensorId/$startTime/$endTime",
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

  Future<Either<AppError, CustomResponse>> generateReportSensorList(
      List<Map<String, String>> optionData,
      String sensorId,
      String startTime,
      String endTime) async {
    try {
      String jsonString = jsonEncode(optionData);

      final response = await _apiClient.postMethodReport(
        "${ApiConstants.reportSensorList}$sensorId/$startTime/$endTime/timezoneMinute/480/frequencyMinute/60",
        body: jsonString,
      );
      CustomResponse customResponse = customResponseFromJson(response);
      return Right(customResponse);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  Future<Either<AppError, CustomResponse>> generateSensorList(
    String areaId,
  ) async {
    try {
      final response = await _apiClient.postMethod(
        "${ApiConstants.sensorList}$areaId/detail",
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
