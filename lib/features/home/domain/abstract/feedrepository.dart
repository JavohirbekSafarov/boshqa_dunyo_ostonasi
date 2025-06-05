import 'feed_item.dart';

abstract class FeedRepository {
  Future<List<FeedItem>> fetchFeed();
  //Future<List<FeedItem>> fetchFeed1({DateTime? since});
  Future<FeedItem> likeItem(FeedItem item);
}
