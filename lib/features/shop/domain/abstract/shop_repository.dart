import '../../data/enties/book_model.dart';

abstract class ShopRepository {
  Future<List<Book>> fetchBooks();
  Future<void> uploadBook(Book book);

}
