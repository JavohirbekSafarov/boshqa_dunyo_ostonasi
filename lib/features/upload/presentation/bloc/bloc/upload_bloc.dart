import 'dart:async';
import 'dart:io';

import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../pic/domain/entities/pic.dart';
import '../../../../poem/domain/entities/poem.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  UploadBloc({
    required this.firestore,
    required this.storage,
    required this.auth,
  }) : super(UploadInitial()) {
    on<UploadRequested>(_onUploadRequested);
  }

  Future<void> _onUploadRequested(
    UploadRequested event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoading());

    try {
      final user = auth.currentUser;
      if (user == null) throw Exception("Foydalanuvchi mavjud emas");

      final id = firestore.collection(AppStrings.POEM_Firebase_model).doc().id;
      final createdAt = DateTime.now();

      if (event.isPoem) {
        final poem = Poem(
          id: id,
          authorId: user.uid,
          author: user.displayName ?? user.email.toString(),
          title: event.title,
          content: event.content ?? "",
          createdAt: createdAt,
          likes: 0,
          type: AppStrings.POEM_Firebase_model,
        );

        await firestore.collection(AppStrings.POEM_Firebase_model).doc(id).set({
          ...poem.toJson(),
          'createdAt': Timestamp.fromDate(createdAt),
        });
      } else {
        // Upload image to Firebase Storage
        final storageRef = storage.ref().child('pic/$id.jpg');
        await storageRef.putFile(event.image!);
        final imageUrl = await storageRef.getDownloadURL();

        final pic = Pic(
          id: id,
          authorId: user.uid,
         author: user.displayName ?? user.email.toString(),
          title: event.title,
          content: imageUrl,
          createdAt: createdAt,
          likes: 0,
          type: AppStrings.PIC_Firebase_model,
        );

        await firestore.collection(AppStrings.PIC_Firebase_model).doc(id).set({
          ...pic.toJson(),
          'createdAt': Timestamp.fromDate(createdAt),
        });
      }

      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure(message: e.toString()));
    }
  }
}
