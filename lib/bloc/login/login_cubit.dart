import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../repositories/auth_repo.dart';

part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _repo = AuthRepo();

  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await _repo.login(email: email, password: password);
      emit(LoginSuccess('Login berhasil!'));
    } catch (e) {
      print(e);
      emit(LoginFailure(e.toString()));
    }
  }
}
