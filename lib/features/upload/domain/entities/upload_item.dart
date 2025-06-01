import '../../../../core/constants/upload_type.dart';

class UploadItem {
  final String title;
  final String content;
  final UploadType type;

  UploadItem({required this.title, required this.content, required this.type});
}
