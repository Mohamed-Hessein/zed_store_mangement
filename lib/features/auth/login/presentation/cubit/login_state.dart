class LoginState {}
class LoginSucess extends LoginState{
  final String code;
  LoginSucess(this.code);
}
class LoginError extends LoginState{

  String errorMassge;
  LoginError(this.errorMassge);
}
class LoginLoading extends LoginState{}
class LoginIntail extends LoginState{}
