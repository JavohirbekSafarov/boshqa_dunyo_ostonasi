import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/domain/abstract/shop_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopRepositoryImpl implements ShopRepository {
  final FirebaseFirestore firestore;

  ShopRepositoryImpl(this.firestore);

  @override
  Future<void> uploadBook(Book book) async {
    await firestore.collection(AppStrings.BOOK_Firebase_model).add(book.toJson());
  }

  @override
  Future<List<Book>> fetchBooks() async {
    final snapshot = await firestore.collection(AppStrings.BOOK_Firebase_model).get();
    return snapshot.docs
        .map((doc) => Book.fromJson(doc.data(), doc.id))
        .toList();
  }
}
