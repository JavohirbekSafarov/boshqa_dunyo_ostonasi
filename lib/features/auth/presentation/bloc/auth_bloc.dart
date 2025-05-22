import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
    on<AuthWithEmailRequested>(_onEmailLogin);
    on<AuthWithGoogleRequested>(_onGoogleLogin);
  }

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      final anonUser = await _auth.signInAnonymously();
      emit(AuthAnonymous());
    } else if (user.isAnonymous) {
      emit(AuthAnonymous());
    } else {
      emit(Authenticated(user.uid));
    }
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    final user = _auth.currentUser;
    if (user != null && !user.isAnonymous) {
      emit(Authenticated(user.uid));
    }
  }

  void _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    final anonUser = await _auth.signInAnonymously();
    emit(AuthAnonymous());
  }

  void _onGoogleLogin(AuthWithGoogleRequested event, Emitter<AuthState> emit) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // bekor qildi

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      emit(Authenticated(userCred.user!.uid));
    } catch (e) {
      print("Google login error: $e");
      emit(AuthAnonymous());
    }
  }

  void _onEmailLogin(AuthWithEmailRequested event, Emitter<AuthState> emit) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = _auth.currentUser;
      if (user != null) {
        emit(Authenticated(user.uid));
        print('+++++++++++++++++++++++++++Email login successfull!');
      }
    } catch (e) {
      print("+++++++++++++++++++++++++++Email login error: $e");
      emit(AuthAnonymous());
    }
  }
}
