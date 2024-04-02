import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_context.dart';
import '../../core/app_error.dart';
import '../../core/preference_helper.dart';
import '../../models/custom_response_model.dart';
import '../../models/dropdown_model.dart';
import '../../repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  late final LoginRepository _loginRepository;

  LoginCubit({required LoginRepository loginRepository})
      : super(LoginInitial()) {
    _loginRepository = loginRepository;
  }

  void loadIpCode(String ipCode) async {
    emit(LoginLoading());
    final Either<AppError, CustomResponse> response =
        await _loginRepository.generateCode(code: ipCode);
    response.fold(
        (l) => emit(IPError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          final ipAddress = r.data['ip'];
          final portNumber = r.data['port'];
          PreferenceHelper.saveBaseUrl(ipAddress + ":" + portNumber);
          emit(const IPInfoLoaded());
        } else {
          emit(IPError(appErrorType: AppErrorType.api, errorMessage: r.data));
        }
      } else {
        emit(IPError(appErrorType: AppErrorType.api, errorMessage: r.data));
      }
    });
  }

  void loadLogin(String email, String password) async {
    emit(LoginLoading());
    final Either<AppError, CustomResponse> response =
        await _loginRepository.generateLoginScreen(
      email: email,
      password: password,
    );
    response.fold(
        (l) => emit(LoginError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          final userId = r.data['userId'];
          PreferenceHelper.saveUserId(userId);
          PreferenceHelper.saveUpdateCheckIfAccountCreated(true);
          emit(const LoginInfoLoaded());
        } else {
          emit(
              LoginError(appErrorType: AppErrorType.api, errorMessage: r.data));
        }
      } else {
        emit(LoginError(appErrorType: AppErrorType.api, errorMessage: r.error));
      }
    });
  }

  void loadDropdownList() async {
    final Either<AppError, CustomResponse> response =
        await _loginRepository.generateDropdownList();
    response.fold(
        (l) => emit(LoginError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          if (r.data is List) {
            final listData =
                (r.data as List).map((e) => ListDropdown.fromJson(e)).toList();
            AppContext().listDropdown = listData;
          } else {
            // Assuming a single object
            final listData = ListDropdown.fromJson(r.data);
            AppContext().listDropdown = [listData];
          }

          emit(const DropdownInfoLoaded());
        } else {
          emit(
              LoginError(appErrorType: AppErrorType.api, errorMessage: r.data));
        }
      } else {
        emit(LoginError(appErrorType: AppErrorType.api, errorMessage: r.data));
      }
    });
  }
}
