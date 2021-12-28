// 1
abstract class AuthCredentials {
  String username;
  String password;

  AuthCredentials({required this.username, required this.password});
}

// 2
class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

// 3
class SignUpCredentials extends AuthCredentials {
  final String email;

  SignUpCredentials({required String username, required String password, required this.email})
      : super(username: username, password: password);
}