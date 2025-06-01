part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String uid;
  final String? email;
  final String? displayName;

  ProfileLoaded({required this.uid, this.email, this.displayName});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class LoggedOut extends ProfileState{
  
}
