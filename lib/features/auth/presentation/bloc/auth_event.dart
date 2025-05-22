part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class AuthWithGoogleRequested extends AuthEvent {}

class AuthWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  AuthWithEmailRequested(this.email, this.password);
}


