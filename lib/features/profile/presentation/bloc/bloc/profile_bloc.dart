import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth;

  ProfileBloc(this._auth) : super(ProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = _auth.currentUser;
        if (user != null) {
          emit(
            ProfileLoaded(
              uid: user.uid,
              email: user.email,
              displayName: user.displayName,
            ),
          );
        } else {
          emit(ProfileError('Foydalanuvchi topilmadi'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateDisplayName>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await user.updateDisplayName(event.displayName);
          add(LoadUserProfile());
        }
      } catch (e) {
        emit(ProfileError('Ismni yangilashda xatolik: $e'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _auth.signOut();
      emit(LoggedOut());
    });
  }
}
