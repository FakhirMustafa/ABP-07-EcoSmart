import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final _auth = FirebaseAuth.instance;

  Future<void> register({required String email, required String password, required String name}) async {
    emit(RegisterLoading());

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload(); 
      emit(RegisterSuccess('Berhasil mendaftar!'));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
