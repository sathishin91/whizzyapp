import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../constants/api_constants.dart';
import '../core/api_client.dart';
import '../core/app_error.dart';
import '../core/preference_helper.dart';
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

  //occupancy list
  Future<Either<AppError, CustomResponse>> generateOccupancyList() async {
    try {
      String ipcode = (await PreferenceHelper.getIpCode())!;
      final response = await _apiClient.postMethod(
        ApiConstants.areaOccupancy,
        params: {
          "token": "",
          "siteCode": ipcode,
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
      String sensorId, String startTime) async {
    try {
      final response = await _apiClient.postMethod(
        "${ApiConstants.dashboardSensorList}$sensorId/${startTime}000000/${startTime}235959",
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
        "${ApiConstants.reportSensorList}$sensorId/$startTime/$endTime/timezoneMinute/480/frequencyMinute/1440",
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

  Future<Either<AppError, CustomResponse>> generateNotificationAll(
      {required String userId}) async {
    try {
      final response = await _apiClient.postMethodReport(
        "${ApiConstants.notificationAll}$userId",
        body: "",
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

  Future<Either<AppError, CustomResponse>> generateActiveSensorList() async {
    try {
      final response = await _apiClient.postMethod(
        ApiConstants.activeSensor,
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
