import 'package:task/bloc/LoginCubit/LoginState.dart';
import 'package:task/repository/authRepository/authRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(InitState());

  Future<String> loginfun(String username, String password) async {
    try {
      final String name = username;
      final String pass = password;

      emit(LoadingState());
      final String result = await authRepository.login(name, pass);
      emit(LoadingState());
      if (result != "Authentication failed") {
        emit(SuccessState(result));
        return "Authentication Done";
      } else {
        emit(ErrorState(result));
        return "Authentication failed";
      }

      // Depending on the result, emit the appropriate state
    } catch (e) {
      return e.toString();
    }
  }
}




// if (result == someCondition) {
// emit(LoginSuccessState(result)); // Change this line accordingly
// } else {
// emit(LoginFailedState('Login failed')); // Change this line accordingly
// }