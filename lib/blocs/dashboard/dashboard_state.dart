part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

class ActiveSensorLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardError extends DashboardState {
  final AppErrorType appErrorType;
  final String? errorMessage;

  const DashboardError({required this.appErrorType, this.errorMessage});

  @override
  List<Object?> get props => [appErrorType, errorMessage];
}

class ActiveSensorError extends DashboardState {
  final AppErrorType appErrorType;
  final String? errorMessage;

  const ActiveSensorError({required this.appErrorType, this.errorMessage});

  @override
  List<Object?> get props => [appErrorType, errorMessage];
}

class DashboardInfoLoaded extends DashboardState {
  // final List<ListDropdown> listDropdown;
  const DashboardInfoLoaded() : super();

  @override
  List<Object> get props => [];
}

class DashboardSensorInfoLoaded extends DashboardState {
  final DashboardSensorList dashboardSensorListCurrentWeek;
  final DashboardSensorList dashboardSensorListLastWeek;
  const DashboardSensorInfoLoaded(
      {required this.dashboardSensorListCurrentWeek,
      required this.dashboardSensorListLastWeek})
      : super();

  @override
  List<Object> get props =>
      [dashboardSensorListCurrentWeek, dashboardSensorListLastWeek];
}

class ReportSensorInfoLoaded extends DashboardState {
  final ReportModel reportModel;
  const ReportSensorInfoLoaded({required this.reportModel}) : super();

  @override
  List<Object> get props => [reportModel];
}

class SensorDataInfoLoaded extends DashboardState {
  final SensorData sensorData;
  const SensorDataInfoLoaded({required this.sensorData}) : super();

  @override
  List<Object> get props => [sensorData];
}

class SensorActiveListInfoLoaded extends DashboardState {
  final List<ActiveSensorData> sensorActiveList;
  const SensorActiveListInfoLoaded({required this.sensorActiveList}) : super();

  @override
  List<Object> get props => [sensorActiveList];
}

class NotificationInfoLoaded extends DashboardState {
  final List<NotificationAll> notificationAll;
  const NotificationInfoLoaded({required this.notificationAll}) : super();

  @override
  List<Object> get props => [notificationAll];
}
