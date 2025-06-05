part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final bool isAdmin;
  Authenticated(this.user, this.isAdmin);
}

class Unauthenticated extends AuthState {
}

class AuthAnonymous extends AuthState {
}