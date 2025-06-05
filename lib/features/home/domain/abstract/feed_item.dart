abstract class FeedItem {
  final String id;
  final String type; // "poem" yoki "pic"
  final String content;
  final String title;
  final String author;
  final String authorId;
  final DateTime createdAt;
  final int likes;

  FeedItem({
    required this.authorId,
    required this.id,
    required this.type,
    required this.content,
    required this.title,
    required this.author,
    required this.createdAt,
    required this.likes,
  });


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
