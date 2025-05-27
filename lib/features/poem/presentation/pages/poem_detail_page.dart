import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PoemDetailPage extends StatelessWidget {
  final Poem poem;

  const PoemDetailPage({super.key, required this.poem});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.read<AuthBloc>().state is Authenticated;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(poem.title),
        actions: [
          isLoggedIn
              ? IconButton(
                onPressed: () {
                  // like logic
                },
                icon: Icon(Icons.favorite_border),
              )
              : IconButton(
                onPressed: () {
                  context.push(AppRoutes.LoginPage);
                },
                icon: Icon(Icons.login),
              ),
        ],
      ),
      body: Padding(padding: EdgeInsets.all(16.0), child: Text(poem.content, style: TextStyle(fontSize: 18))),
   /*   floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'prev',
            onPressed: () {
              // oldingi she’rga o‘tish (state’dan yoki route’dan foydalanib)
            },
            child: Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.small(
            heroTag: 'next',
            onPressed: () {
              // keyingi she’rga o‘tish
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),*/
    );
  }
}
