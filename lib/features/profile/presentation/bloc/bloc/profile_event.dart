part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateDisplayName extends ProfileEvent {
  final String displayName;
  UpdateDisplayName(this.displayName);
}

class LogoutRequested extends ProfileEvent {}