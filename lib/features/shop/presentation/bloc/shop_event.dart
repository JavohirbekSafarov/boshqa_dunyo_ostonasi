part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent {}

class LoadBooks extends ShopEvent {}
class AddBook extends ShopEvent {
  final Book book;
  AddBook(this.book);
}