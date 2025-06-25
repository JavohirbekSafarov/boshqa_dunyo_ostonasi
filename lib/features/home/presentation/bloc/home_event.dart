part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFeed extends HomeEvent {}

class RefreshFeed extends HomeEvent {}

class LikeItem extends HomeEvent {
  final FeedItem item;
  final String userId;
  const LikeItem(this.item, this.userId);
}

class DeleteItem extends HomeEvent {
  final FeedItem item;
  const DeleteItem(this.item);
}
