part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String msg;

  const LoginSuccess(this.msg);

  @override
  List<Object?> get props => [msg];
}

class LoginFailure extends LoginState {
  final String msg;

  const LoginFailure(this.msg);

  @override
  List<Object?> get props => [msg];
}
