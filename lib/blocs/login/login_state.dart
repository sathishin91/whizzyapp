part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginState {
  final AppErrorType appErrorType;
  final String? errorMessage;

  const LoginError({required this.appErrorType, this.errorMessage});

  @override
  List<Object?> get props => [appErrorType, errorMessage];
}

class IPError extends LoginState {
  final AppErrorType appErrorType;
  final String? errorMessage;

  const IPError({required this.appErrorType, this.errorMessage});

  @override
  List<Object?> get props => [appErrorType, errorMessage];
}

class IPInfoLoaded extends LoginState {
  const IPInfoLoaded() : super();

  @override
  List<Object> get props => [];
}

class LoginInfoLoaded extends LoginState {
  const LoginInfoLoaded() : super();

  @override
  List<Object> get props => [];
}

class DropdownInfoLoaded extends LoginState {
  // final List<ListDropdown> listDropdown;
  const DropdownInfoLoaded() : super();

  @override
  List<Object> get props => [];
}
