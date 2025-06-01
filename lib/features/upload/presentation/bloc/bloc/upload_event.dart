part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadRequested extends UploadEvent {
  final bool isPoem;
  final String title;
  final String? content;
  final File? image;

  const UploadRequested({
    required this.isPoem,
    required this.title,
    this.content,
    this.image,
  });

  @override
  List<Object?> get props => [isPoem, title, content, image];
}
