import 'dart:io';

import 'package:dartz/dartz.dart';

import '../constants/api_constants.dart';
import '../core/api_client.dart';
import '../core/app_error.dart';
import '../models/custom_response_model.dart';

class LoginRepository {
  final ApiClient _apiClient;

  LoginRepository(this._apiClient);

  Future<Either<AppError, CustomResponse>> generateCode(
      {required String code}) async {
    try {
      final response = await _apiClient.postMethod(
        ApiConstants.serverInfo,
        params: {
          "code": code,
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

  Future<Either<AppError, CustomResponse>> generateLoginScreen(
      {required String email, required String password}) async {
    try {
      final response = await _apiClient.postMethod(
        ApiConstants.loginApp,
        params: {
          "email": email,
          "password": password,
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
