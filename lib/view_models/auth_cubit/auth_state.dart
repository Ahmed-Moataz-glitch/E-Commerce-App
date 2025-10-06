part of 'auth_cubit.dart';

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthDone extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class AuthLoggedOut extends AuthState {}

final class AuthLoggingOut extends AuthState {}

final class AuthLogOutError extends AuthState {
  final String message;

  AuthLogOutError(this.message);
}

final class GoogleAuthenticating extends AuthState {}

final class GoogleAuthError extends AuthState {
  final String message;

  GoogleAuthError(this.message);
}

final class GoogleAuthDone extends AuthState {}

final class FacebookAuthenticating extends AuthState {}

final class FacebookAuthError extends AuthState {
  final String message;

  FacebookAuthError(this.message);
}

final class FacebookAuthDone extends AuthState {}