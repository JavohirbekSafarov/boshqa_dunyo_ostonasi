import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PoemDetailPage extends StatefulWidget {
  final Poem poem;

  const PoemDetailPage({super.key, required this.poem});

  @override
  State<PoemDetailPage> createState() => _PoemDetailPageState();
}

class _PoemDetailPageState extends State<PoemDetailPage> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.read<AuthBloc>().state is Authenticated;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        title: Text(widget.poem.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          isLoggedIn
              ? IconButton(
                icon: Icon(Icons.favorite_border, color: _isLiked ? Colors.red : Colors.white),
                onPressed: () {
                  if (!_isLiked) {
                    context.read<HomeBloc>().add(LikeItem(widget.poem));
                    setState(() {
                      _isLiked = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yoqtirilgan!')));
                  }
                },
              )
              : IconButton(
                onPressed: () {
                  context.push(AppRoutes.LoginPage);
                },
                icon: Icon(Icons.login),
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(child: Text(widget.poem.content, style: TextStyle(fontSize: 18))),

            ),
          ],
        ),
      ),

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
