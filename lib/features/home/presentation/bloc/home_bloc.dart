import 'package:bloc/bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/domain/abstract/feed_item.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:equatable/equatable.dart';

import '../../../poem/domain/entities/poem.dart';
import '../../domain/abstract/feedrepository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FeedRepository repository;



  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadFeed>((event, emit) async {
      emit(HomeLoading());
      // Mock data. Firebase bilan keyin ulaymiz
     // await Future.delayed(Duration(seconds: 1));
    /*  final List<FeedItem> data = [
        Poem(
          id: '1',
          type: 'poem',
          content: 'Hayot - bu sinov',
          author: 'Ali',
          title: 'Hayot haqida',
          likes: 5,
          authorId: '1',
        ),
        Pic(
          id: '2',
          type: 'pic',
          title: 'Qanaqadir rasm',
          content: 'https://yavuzceliker.github.io/sample-images/image-1.jpg',
          author: 'Zara',
          likes: 2,
          authorId: '2',
        ),
        Poem(
          id: '3',
          type: 'poem',
          title: 'Lorem sher',
          content:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
          author: 'MuxiddinRich',
          likes: 15,
          authorId: '3',
        ),
        Pic(
          id: '4',
          type: 'pic',
          title: 'Sample image',
          content: 'https://sample-videos.com/img/Sample-png-image-1mb.png',
          author: 'Rich bitch',
          likes: 5,
          authorId: '4',
        ),
      ];
*/

      final items = await repository.fetchFeed();
//      emit(FeedLoaded(items));

      emit(HomeLoaded(items));
    });
  }
}
