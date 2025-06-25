import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

class PoemDetailPage extends StatefulWidget {
  final Poem poem;

  const PoemDetailPage({super.key, required this.poem});

  @override
  State<PoemDetailPage> createState() => _PoemDetailPageState();
}

class _PoemDetailPageState extends State<PoemDetailPage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.uid : null;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        title: Text(
          widget.poem.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          userId != null
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(AppStrings.USER_Firebase_model)
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool isLiked = false;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      final likedPosts = List<dynamic>.from(
                          (snapshot.data!.data() as Map<String, dynamic>)['likedPosts'] ?? []);
                      isLiked = likedPosts.contains(widget.poem.id);
                    }

                    return IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        if (authState is Authenticated) {
                          if (!isLiked) {
                            context.read<HomeBloc>().add(
                                  LikeItem(widget.poem, authState.user.uid),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bu sheʼr allaqachon yoqtirilgan!')),
                            );
                          }
                        }
                      },
                    );
                  },
                )
              : IconButton(
                  onPressed: () {
                    context.go(AppRoutes.LoginPage);
                  },
                  icon: const Icon(LineIcons.doorClosed, color: Colors.white),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.poem.content,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}