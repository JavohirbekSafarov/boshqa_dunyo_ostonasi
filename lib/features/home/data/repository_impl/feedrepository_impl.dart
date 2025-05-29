import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../pic/data/models/pic_model.dart';
import '../../../poem/data/models/poem_model.dart';
import '../../domain/abstract/feed_item.dart';
import '../../domain/abstract/feedrepository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FirebaseFirestore firestore;

  FeedRepositoryImpl({required this.firestore});

  @override
  Future<List<FeedItem>> fetchFeed() async {
    final poemsSnapshot = await firestore.collection('poem').get();
    final picsSnapshot = await firestore.collection('pic').get();

    final poems =
        poemsSnapshot.docs
            .map((doc) => PoemModel.fromJson(doc.data()).toEntity())
            .toList();

    final pics =
        picsSnapshot.docs
            .map((doc) => PicModel.fromJson(doc.data()).toEntity())
            .toList();

    // combine and sort
    final all = [...poems, ...pics];
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // recent first

    return all;
  }

  @override
  Future<void> likeItem(String collection, String id) async {
    // final docRef = firestore.collection(collection).doc(id);
    // await firestore.runTransaction((transaction) async {
    //   final snapshot = await transaction.get(docRef);
    //   final currentLikes = snapshot['likes'] ?? 0;
    //   transaction.update(docRef, {'likes': currentLikes + 1});
    // });

    print('++++++++++++++++Like adding... feed repo impl dart');
    final docRef = firestore.collection(collection).doc(id);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final currentLikes = snapshot.data()?['likes'] ?? 0;
      transaction.update(docRef, {'likes': currentLikes + 1});
    });

    // Create a reference to the document the transaction will use
    // DocumentReference documentReference = FirebaseFirestore.instance
    //     .collection(collection)
    //     .doc(id);

    // return FirebaseFirestore.instance
    //     .runTransaction((transaction) async {
    //       // Get the document
    //       DocumentSnapshot snapshot = await transaction.get(documentReference);

    //       if (!snapshot.exists) {
    //         throw Exception("Item does not exist!");
    //       }

    //       // Update the follower count based on the current count
    //       // Note: this could be done without a transaction
    //       // by updating the population using FieldValue.increment()

    //       int newFollowerCount = snapshot['likes'] ?? 0 + 1;

    //       // Perform an update on the document
    //       transaction.update(documentReference, {
    //         'likes': newFollowerCount,
    //       });

    //       // Return the new count
    //       return newFollowerCount;
    //     })
    //     .then((value) => print("Follower count updated to $value"))
    //     .catchError(
    //       (error) => print("Failed to update user followers: $error"),
    //     );
  }
}
