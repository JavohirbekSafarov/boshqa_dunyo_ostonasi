import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../pic/data/models/pic_model.dart';
import '../../../poem/data/models/poem_model.dart';
import '../../domain/abstract/feed_item.dart';
import '../../domain/abstract/feedrepository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FirebaseFirestore firestore;

  FeedRepositoryImpl({required this.firestore});

  @override
  Future<List<FeedItem>> fetchFeed() async {
    final poemsSnapshot = await firestore.collection(AppStrings.POEM_Firebase_model).get();
    final picsSnapshot = await firestore.collection(AppStrings.PIC_Firebase_model).get();

    final poems = poemsSnapshot.docs.map((doc) => PoemModel.fromJson(doc.data()).toEntity()).toList();

    final pics = picsSnapshot.docs.map((doc) => PicModel.fromJson(doc.data()).toEntity()).toList();

    // combine and sort
    final all = [...poems, ...pics];
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // recent first

    return all;
  }

  // @override
  // Future<FeedItem> likeItem(FeedItem item) async {
  //   final collection = item.type;
  //   final docRef = firestore.collection(collection).doc(item.id);

  //   await docRef.update({'likes': item.likes + 1}).then((value) {
  //     print('++++++++++++++++++ Like added ');
  //   });

  //   if (item.type == AppStrings.POEM_Firebase_model) {
  //     return PoemModel(
  //       authorId: item.author,
  //       author: item.author,
  //       content: item.content,
  //       createdAt: item.createdAt,
  //       id: item.id,
  //       likes: item.likes + 1,
  //       title: item.title,
  //       type: item.type,
  //     ).toEntity();
  //   } else {
  //     return PicModel(
  //       authorId: item.author,
  //       author: item.author,
  //       content: item.content,
  //       createdAt: item.createdAt,
  //       id: item.id,
  //       likes: item.likes + 1,
  //       title: item.title,
  //       type: item.type,
  //     ).toEntity();
  //   }
@override
  Future<FeedItem> likeItem(FeedItem item, String userId) async {
    final collection = item.type;
    final docRef = firestore.collection(collection).doc(item.id);
    final userRef = firestore.collection(AppStrings.USER_Firebase_model).doc(userId);

    return await firestore.runTransaction((transaction) async {
      // Get the user document to check likedPosts
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw Exception("User does not exist!");
      }

      // Get the current likedPosts array or initialize as empty
      final likedPosts = List<String>.from(userSnapshot.data()?['likedPosts'] ?? []);

      // Check if the user has already liked the post
      if (likedPosts.contains(item.id)) {
        throw Exception("User has already liked this post!");
      }

      // Get the post document
      final postSnapshot = await transaction.get(docRef);
      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      // Increment likes count
      final currentLikes = postSnapshot.data()?['likes'] ?? 0;
      transaction.update(docRef, {'likes': currentLikes + 1});

      // Add post ID to user's likedPosts
      transaction.update(userRef, {
        'likedPosts': FieldValue.arrayUnion([item.id]),
      });

      // Return updated FeedItem
      if (item.type == AppStrings.POEM_Firebase_model) {
        return PoemModel(
          authorId: item.author,
          author: item.author,
          content: item.content,
          createdAt: item.createdAt,
          id: item.id,
          likes: currentLikes + 1,
          title: item.title,
          type: item.type,
        ).toEntity();
      } else {
        return PicModel(
          authorId: item.author,
          author: item.author,
          content: item.content,
          createdAt: item.createdAt,
          id: item.id,
          likes: currentLikes + 1,
          title: item.title,
          type: item.type,
        ).toEntity();
      }
    }).catchError((error) {
      print("Failed to like post: $error");
      throw error; // Rethrow to handle in UI
    });
  

    //print('++++++++++++++++Like adding... feed repo impl dart');
    /*final docRef = firestore.collection(collection).doc(id);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final currentLikes = snapshot.data()?['likes'] ?? 0;
      transaction.update(docRef, {'likes': currentLikes + 1});
    });*/

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
