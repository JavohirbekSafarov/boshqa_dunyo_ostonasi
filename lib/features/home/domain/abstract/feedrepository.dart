import 'feed_item.dart';

abstract class FeedRepository {
  Future<List<FeedItem>> fetchFeed();
}
