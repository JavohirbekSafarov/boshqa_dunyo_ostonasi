import 'package:boshqa_dunyo_ostonasi/features/home/domain/abstract/feed_item.dart';
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
  }

  void _homeLoad(LoadFeed event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final items = await repository.fetchFeed();
    emit(HomeLoaded(items));
  }

  void _homeReload(RefreshFeed event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final items = await repository.fetchFeed();
    emit(HomeLoaded(items));
  }

  void _likeItem(LikeItem event, Emitter<HomeState> emit) async {
    try {
      await repository.likeItem(event.item.type, event.item.id);
      add(RefreshFeed());
    } catch (e) {
      emit(HomeError('Like bosishda xatolik: $e'));
    }
  }
}
