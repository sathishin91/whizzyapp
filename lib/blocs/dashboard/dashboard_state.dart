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
