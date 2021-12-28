import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

import 'auth_credentials.dart';

// 1
enum AuthFlowStatus { login, signUp, verification, session }

// 2
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

// 3
class AuthService {
  // 4
  final authStateController = StreamController<AuthState>();
  late final AuthCredentials _credentials;

  // 5
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // 6
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  // 1
  Future<void> loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: credentials.username, password: credentials.password);

      if (result.isSignedIn) {
        // サインイン後の処理
        _credentials.username = credentials.username;
        
      } else {
        // サインイン失敗
      }
    } on AuthException catch (authError) {
      print('Could not login - ${authError.message}');
    }
  }

  // 2
  Future<void> signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};

      final result = await Amplify.Auth.signUp(
        username: credentials.username,
        password: credentials.password,
        options: CognitoSignUpOptions(userAttributes: userAttributes));

      if (result.isSignUpComplete) {
          // サインアップ後の処理
      } else {
          // サインアップ未完了
      }
    } on AuthException catch (authError) {
      print('Failed to sign up - ${authError.message}');
    }
  }

  Future<void> verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: _credentials.username, confirmationCode: verificationCode);

      if (result.isSignUpComplete) {
          // サインアップ後の処理
      } else {
          // サインアップ未完了
      }
    } on AuthException catch (authError) {
      print('Could not verify code - ${authError.message}');
    }
  }

  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
      // サインアウト後の処理
    } on AuthException catch (authError) {
      print('Could not log out - ${authError.message}');
    }
  }
}