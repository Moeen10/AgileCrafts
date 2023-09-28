import 'package:task/bloc/LoginCubit/LoginState.dart';
import 'package:task/repository/authRepository/authRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(InitState());

  void loginfun(String username, String password) async {
    try {
      final String name = username;
      final String pass = password;

      emit(LoadingState());
      final String result = await authRepository.login(name, pass);
      emit(LoadingState());
      if (result != "Authentication failed") {
        emit(SuccessState(result));
      } else {
        emit(ErrorState(result));
      }

      // Depending on the result, emit the appropriate state
    } catch (e) {
      // emit(LoginFailedState('An error occurred: $e')); /
    }
  }
}




// if (result == someCondition) {
// emit(LoginSuccessState(result)); // Change this line accordingly
// } else {
// emit(LoginFailedState('Login failed')); // Change this line accordingly
// }