import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizzy/constants/app_context.dart';
import 'package:whizzy/models/dropdown_model.dart';
import 'package:whizzy/repository/dashboard_repository.dart';

import '../../core/app_error.dart';
import '../../models/custom_response_model.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  late final DashboardRepository _dashboardRepository;

  DashboardCubit({required DashboardRepository dashboardRepository})
      : super(DashboardInitial()) {
    _dashboardRepository = dashboardRepository;
  }

  void loadDropdownList() async {
    emit(DashboardLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateDropdownList();
    response.fold(
        (l) => emit(DashboardError(
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

          emit(const DashboardInfoLoaded());
        } else {
          emit(DashboardError(
              appErrorType: AppErrorType.api, errorMessage: r.data));
        }
      } else {
        emit(DashboardError(
            appErrorType: AppErrorType.api, errorMessage: r.data));
      }
    });
  }
}
