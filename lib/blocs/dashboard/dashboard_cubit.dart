import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_context.dart';
import '../../core/app_error.dart';
import '../../models/custom_response_model.dart';
import '../../models/dropdown_model.dart';
import '../../models/notify_model.dart';
import '../../models/reportModel.dart';
import '../../models/sensorListDashboard.dart';
import '../../models/sensorModel.dart';
import '../../repository/dashboard_repository.dart';

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

  //occupancy data list
  void occupancyList() async {
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateOccupancyList();
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final List<dynamic> dataList = r.data;
          final List<OccupancyData> notificationAllList = dataList.map((item) {
            if (item is Map<String, dynamic>) {
              return OccupancyData.fromJson(item);
            } else {
              throw FormatException("Invalid data format: $item");
            }
          }).toList();
          emit(OccupancyInfoLoaded(occupancyData: notificationAllList));
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

  // "${ApiConstants.dashboardSensorList}5487C344-00CC-4020-9A46-CF249395908D/20231201080000/20231201235959",
  void dashboardSensorList(
    String sensorId,
    String startTime,
    String endTime,
  ) async {
    emit(DashboardLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateDashboardSensorList(
      sensorId = sensorId,
      startTime = startTime,
    );
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final listData = DashboardSensorList.fromJson(r.data);
          chartDataLastWeek(sensorId, endTime, listData);
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

  void chartDataLastWeek(
    String sensorId,
    String startTime,
    DashboardSensorList listDataCurrentWeek,
  ) async {
    emit(DashboardLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateDashboardSensorList(
      sensorId = sensorId,
      startTime = startTime,
    );
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final listData = DashboardSensorList.fromJson(r.data);
          emit(DashboardSensorInfoLoaded(
            dashboardSensorListCurrentWeek: listDataCurrentWeek,
            dashboardSensorListLastWeek: listData,
          ));
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

  void reportSensorList(
    List<Map<String, String>> optionData,
    String sensorId,
    String startTime,
    String endTime,
  ) async {
    emit(DashboardLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateReportSensorList(
      optionData = optionData,
      sensorId = sensorId,
      startTime = startTime,
      endTime = endTime,
    );
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final listData = ReportModel.fromJson(r.data);
          emit(ReportSensorInfoLoaded(reportModel: listData));
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

  //sensordata retrieve based on dropdown areaid
  void areaSensorList(
    String areaId,
  ) async {
    emit(DashboardLoading());

    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateSensorList(
      areaId = areaId,
    );
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final listData = SensorData.fromJson(r.data);
          emit(SensorDataInfoLoaded(sensorData: listData));
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

  // sensor active list
  void activeSensorList() async {
    emit(ActiveSensorLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateActiveSensorList();
    response.fold(
        (l) => emit(ActiveSensorError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          List<dynamic> dataList = r.data;
          List<Map<String, dynamic>> jsonDataList =
              dataList.cast<Map<String, dynamic>>();

          List<ActiveSensorData> sensorDataList = jsonDataList
              .map((data) => ActiveSensorData.fromJson(data))
              .toList();

          emit(SensorActiveListInfoLoaded(sensorActiveList: sensorDataList));
        } else {
          emit(ActiveSensorError(
              appErrorType: AppErrorType.api, errorMessage: r.data));
        }
      } else {
        emit(ActiveSensorError(
            appErrorType: AppErrorType.api, errorMessage: r.data));
      }
    });
  }

  void notificationListAll(
    String userId,
  ) async {
    emit(DashboardLoading());
    final Either<AppError, CustomResponse> response =
        await _dashboardRepository.generateNotificationAll(userId: userId);
    response.fold(
        (l) => emit(DashboardError(
              appErrorType: l.appErrorType,
            )), (r) {
      if (r.success) {
        if (r.data != null) {
          // Assuming a single object
          final List<dynamic> dataList = r.data;
          final List<NotificationAll> notificationAllList =
              dataList.map((item) {
            if (item is Map<String, dynamic>) {
              return NotificationAll.fromJson(item);
            } else {
              throw FormatException("Invalid data format: $item");
            }
          }).toList();
          emit(NotificationInfoLoaded(notificationAll: notificationAllList));
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
