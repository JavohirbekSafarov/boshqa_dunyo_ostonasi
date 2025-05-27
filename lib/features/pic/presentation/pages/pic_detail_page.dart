import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/pic.dart';

class PicDetailPage extends StatelessWidget {
  final Pic pic;

  const PicDetailPage({super.key, required this.pic});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.read<AuthBloc>().state is Authenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(pic.title),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // like qilish logikasi
              },
            )
          else
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () => context.push('/login'),
            ),
        ],
      ),
      body: Center(
        child: Image.network(pic.content),
      ),
    /*  floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'prev_pic',
            onPressed: () {
              // oldingi rasmga o‘tish
            },
            child: Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.small(
            heroTag: 'next_pic',
            onPressed: () {
              // keyingi rasmga o‘tish
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),*/
    );
  }
}
