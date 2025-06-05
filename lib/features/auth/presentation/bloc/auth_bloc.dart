import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      // ignore: unused_local_variable
      final anonUser = await _auth.signInAnonymously();
      emit(AuthAnonymous());
    } else if (user.isAnonymous) {
      emit(AuthAnonymous());
    } else {
      bool isAdmin = await checkIfAdmin(user.uid);
      emit(Authenticated(user, isAdmin));
    }
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    if (user != null && !user.isAnonymous) {
      bool isAdmin = await checkIfAdmin(user.uid);
      emit(Authenticated(user, isAdmin));
    }
  }

  void _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    // ignore: unused_local_variable
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
      createUserInFirestore(userCred.user!);
      bool isAdmin = await checkIfAdmin(userCred.user!.uid);
      emit(Authenticated(userCred.user!, isAdmin));
    } catch (e) {
      print('Google login error: $e');
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
        createUserInFirestore(user);
        bool isAdmin = await checkIfAdmin(user.uid);
        emit(Authenticated(user, isAdmin));
        print('+++++++++++++++++++++++++++Email login successfull!');
      }
    } catch (e) {
      print('+++++++++++++++++++++++++++Email login error: $e');
      emit(AuthAnonymous());
    }
  }

  ///  BU FAQAT USER CREATE BOLGANDA CHAQIRISH KERAK, LOGINDA EMAS
  Future<void> createUserInFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance.collection(AppStrings.USER_Firebase_model).doc(user.uid);
    final exists = await userDoc.get();

    if (!exists.exists) {
      await userDoc.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'isAdmin': false, // Default false
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> checkIfAdmin(String uid) async {
    final doc = await FirebaseFirestore.instance.collection(AppStrings.USER_Firebase_model).doc(uid).get();
    return doc.exists && doc.data()?['isAdmin'] == true;
  }
}
