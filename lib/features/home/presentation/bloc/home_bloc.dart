import 'package:boshqa_dunyo_ostonasi/features/home/domain/abstract/feed_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/abstract/feedrepository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FeedRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadFeed>(_homeLoad);
    on<RefreshFeed>(_homeReload);
    on<LikeItem>(_likeItem);
    on<DeleteItem>(_deleteItem);
  }

  void _deleteItem(DeleteItem event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      //await repository.deleteItem(event.item);

      final col = event.item.type;
      await FirebaseFirestore.instance
          .collection(col)
          .doc(event.item.id)
          .delete();

      final updated =
          currentState.items.where((e) => e.id != event.item.id).toList();
      emit(HomeLoading());
      emit(HomeLoaded(updated));
    }
  }

  void _homeLoad(LoadFeed event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final items = await repository.fetchFeed();
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _homeReload(RefreshFeed event, Emitter<HomeState> emit) async {
    final items = await repository.fetchFeed();
    emit(HomeLoading());
    emit(HomeLoaded(items));
    /*
    final currentState = state;
    if (currentState is HomeLoaded) {
      //final lastTime = currentState.items.map((e) => e.createdAt).reduce((a, b) => a.isAfter(b) ? a : b);
      //final lastTime = currentState.items.last.createdAt;
      final lastTime = currentState.items
          .map((e) => e.createdAt)
          .fold<DateTime>(DateTime.fromMillisecondsSinceEpoch(0), (a, b) => a.isAfter(b) ? a : b);

      final newItems = await repository.fetchFeed1(since: lastTime);

      print(' +++++++++++++++++ last time $lastTime');

      print(' ++++++++++++++++++ new items: \n$newItems');

      final updated = [...newItems];
      updated.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(HomeLoading());
      emit(HomeLoaded(updated));
    } else {
      add(LoadFeed());
    }*/
  }

  void _likeItem(LikeItem event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final updatedItem = await repository.likeItem(event.item, event.userId);

      final updatedList =
          currentState.items.map((item) {
            return item.id == updatedItem.id ? updatedItem : item;
          }).toList();

      emit(HomeLoading());
      emit(HomeLoaded(updatedList));
    }
  }
}
