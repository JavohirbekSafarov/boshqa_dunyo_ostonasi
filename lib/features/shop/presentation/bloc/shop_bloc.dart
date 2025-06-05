import 'package:bloc/bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/domain/abstract/shop_repository.dart';
import 'package:meta/meta.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository repository;

  ShopBloc(this.repository) : super(BookInitial()) {
    on<LoadBooks>((event, emit) async {
      emit(BookLoading());
      try {
        final books = await repository.fetchBooks();
        emit(BookLoaded(books));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    });

    on<AddBook>((event, emit) async {
      if (state is BookLoaded) {
        try {
          await repository.uploadBook(event.book);
          final books = await repository.fetchBooks();
          emit(BookLoaded(books));
        } catch (e) {
          emit(BookError(e.toString()));
        }
      }
    });
  }
}

