import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
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
        title: Text(
          'Home page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
        builder:
            (context, state) => RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshFeed());
              },
              child: _buildBody(state),
            ),
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    switch (state.runtimeType) {
      case HomeLoading:
        return const Center(child: CircularProgressIndicator());

      case HomeLoaded:
        final loadedState = state as HomeLoaded;
        return loadedState.items.isNotEmpty
            ? ListView.builder(
              itemCount: loadedState.items.length,
              itemBuilder: (_, index) {
                final item = loadedState.items[index];
                return FeedItemTile(item: item);
              },
            )
            : const Center(child: Text('Ma\'lumotlar mavjud emas!'));

      case HomeError:
        final errorState = state as HomeError;
        return Center(child: Text('Xatolik: ${errorState.message}'));

      default:
        return const SizedBox();
    }
  }
}
