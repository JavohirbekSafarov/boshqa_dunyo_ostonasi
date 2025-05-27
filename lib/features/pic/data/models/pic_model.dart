
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_strings.dart';

class PicModel {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final DateTime createdAt;
  final String type;
  final int likes;

  PicModel({
    required this.authorId, 
    required this.type, 
    required this.likes, 
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory PicModel.fromJson(Map<String, dynamic> json) {
    return PicModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      createdAt: (json['createdAt'] as Timestamp).toDate(), 
      authorId: (json['authorId']), 
      type: AppStrings.PIC, 
      likes: (json['likes']),
    );
  }

  Pic toEntity() => Pic(
    id: id,
    title: title,
    content: content,
    author: author,
    //createdAt: createdAt,
    authorId: authorId,
    likes: likes,
    type: type
  );
}
