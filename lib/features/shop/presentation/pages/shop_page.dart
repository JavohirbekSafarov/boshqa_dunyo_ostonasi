import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    context.read<ShopBloc>().add(LoadBooks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.SHOP_PAGE_TITLE,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
          ),
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
                return BookCard(
                  imageUrl: book.coverUrl,
                  title: book.title,
                  author: book.author,
                  onTap: () {
                    context.push(AppRoutes.BookDetailPage, extra: book);
                  },
                );
                // return ListTile(
                //   leading: Image.network(book.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                //   title: Text(book.title),
                //   subtitle: Text(book.author),
                //   onTap: () {
                //     context.push(AppRoutes.BookDetailPage, extra: book);
                //   },
                // );
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
