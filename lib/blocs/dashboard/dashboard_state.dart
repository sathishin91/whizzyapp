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

class DashboardError extends DashboardState {
  final AppErrorType appErrorType;
  final String? errorMessage;

  const DashboardError({required this.appErrorType, this.errorMessage});

  @override
  List<Object?> get props => [appErrorType, errorMessage];
}

class DashboardInfoLoaded extends DashboardState {
  const DashboardInfoLoaded() : super();

  @override
  List<Object> get props => [];
}

class DashboardSensorInfoLoaded extends DashboardState {
  final DashboardSensorList dashboardSensorList;
  const DashboardSensorInfoLoaded({required this.dashboardSensorList})
      : super();

  @override
  List<Object> get props => [dashboardSensorList];
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
