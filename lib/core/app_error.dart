import 'package:equatable/equatable.dart';

//Class used to handle app errors
class AppError extends Equatable {
  final AppErrorType appErrorType;

  const AppError(this.appErrorType);

  @override
  List<Object?> get props => [appErrorType];
}

enum AppErrorType {
  api,
  network,
  database,
  unauthorised,
  sessionDenied,
  versionNotSupported,
  versionUpdateAvailable,
}
