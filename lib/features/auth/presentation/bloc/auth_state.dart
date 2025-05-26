part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  Authenticated(this.userId);
}

class Unauthenticated extends AuthState {
}

class AuthAnonymous extends AuthState {
}