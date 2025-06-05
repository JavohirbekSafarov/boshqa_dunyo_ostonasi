import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/poem.dart';

class PoemModel {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final DateTime createdAt;
  final String type;
  final int likes;

  PoemModel({
    required this.authorId,
    required this.type,
    required this.likes,
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory PoemModel.fromJson(Map<String, dynamic> json) {
    return PoemModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      authorId: (json['authorId']),
      type: AppStrings.POEM_Firebase_model,
      likes: (json['likes']),
    );
  }

  Poem toEntity() => Poem(
    id: id,
    title: title,
    content: content,
    author: author,
    createdAt: createdAt,
    authorId: authorId,
    likes: likes,
    type: type,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'title': title,
      'author': author,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
    };
  }
}
