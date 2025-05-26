import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../pic/data/models/pic_model.dart';
import '../../../poem/data/models/poem_model.dart';
import '../../domain/abstract/feed_item.dart';
import '../../domain/abstract/feedrepository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FirebaseFirestore firestore;

  FeedRepositoryImpl(this.firestore);

  @override
  Future<List<FeedItem>> fetchFeed() async {
    final poemsSnapshot = await firestore.collection('poems').get();
    final picsSnapshot = await firestore.collection('pics').get();

    final poems = poemsSnapshot.docs
        .map((doc) => PoemModel.fromJson(doc.data()).toEntity())
        .toList();

    final pics = picsSnapshot.docs
        .map((doc) => PicModel.fromJson(doc.data()).toEntity())
        .toList();

    // combine and sort
    final all = [...poems, ...pics];
    //all.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // recent first

    return all;
  }
}
