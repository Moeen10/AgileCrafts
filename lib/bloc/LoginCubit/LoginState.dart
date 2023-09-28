

abstract class LoginState{}

class InitState extends LoginState{}
class LoadingState extends LoginState{}
class SuccessState extends LoginState{
  final String token;
  SuccessState(this.token);
}
class ErrorState extends LoginState{
  final String errorMessage;
  ErrorState(this.errorMessage);
}