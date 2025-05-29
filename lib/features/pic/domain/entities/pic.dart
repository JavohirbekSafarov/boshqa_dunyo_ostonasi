import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/domain/abstract/feed_item.dart';

class Pic extends FeedItem {
  @override
  final String type = AppStrings.PIC;
  Pic({
    required super.authorId,
    required super.id,
    required super.type,
    required super.content,
    required super.author,
    required super.createdAt,
    required super.likes,
    required super.title,
  });
}
