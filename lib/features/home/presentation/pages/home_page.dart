import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/home_bloc.dart';
import '../widgets/feed_item_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        backgroundColor: Colors.blueGrey,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is! Authenticated) {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    context.go(AppRoutes.LoginPage);
                  },
                );
              }
              return const SizedBox(); // Login bo'lgan foydalanuvchiga hech nima
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[100],
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return state.items.isNotEmpty
                ? ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (_, index) {
                    final item = state.items[index];
                    return FeedItemTile(item: item);
                  },
                )
                : const Center(child: Text('Ma\'lumotlar mavjud emas!'));
          } else if (state is HomeError) {
            return Center(child: Text('Xatolik: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return state is Authenticated
              ? FloatingActionButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('poem')
                      .add({
                        'id': 'poem_001',
                        'type': 'poem',
                        'title': 'Bahor Nafasi',
                        'content': 'Bahor keldi, gullar ochildi...',
                        'author': 'Alisher Navoi',
                        'authorId': state.userId,
                        'likes': 0,
                        'createdAt': FieldValue.serverTimestamp(),
                      })
                      .then((onValue) => print('++++++++++++++++++++++Poem added!'));
                },
                child: Text('Add'),
              )
              : const SizedBox();
        },
      ),
    );
  }
}
