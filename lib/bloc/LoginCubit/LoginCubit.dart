import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/LoginCubit/LoginState.dart';
import 'package:task/models/authenticationModel.dart';
import 'package:task/repository/authRepository/authRepo.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository; // Declare the authRepository as a field

  LoginCubit(this.authRepository) : super(InitState());

  void loginfun(String username, String password) async {
    try {
      final String name = username;
      final String pass = password;

      // Assuming authRepository.login returns some result or throws an exception
      emit(LoadingState());
      final String result = await authRepository.login(name, pass);
      if(result == "Authentication failed"){
        emit(ErrorState(result));
      }
      else{
        emit(SuccessState(result));
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