part of 'shop_bloc.dart';

@immutable
sealed class ShopState {}

class BookInitial extends ShopState {}

class BookLoading extends ShopState {}

class BookLoaded extends ShopState {
  final List<Book> books;

  BookLoaded(this.books);
}

class BookError extends ShopState {
  final String message;

  BookError(this.message);
}
