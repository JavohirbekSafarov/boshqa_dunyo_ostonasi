import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/enties/book_model.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueGrey,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated && state.isAdmin) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {
                    context.push(AppRoutes.BookUploadPage);
                  },
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookLoaded) {
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (_, index) {
                final book = state.books[index];
                return ListTile(
                  leading: Image.network(book.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () {
                    context.push(AppRoutes.BookDetailPage, extra: book);
                  },
                );
              },
            );
          } else if (state is BookError) {
            return Center(child: Text('Xatolik: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
