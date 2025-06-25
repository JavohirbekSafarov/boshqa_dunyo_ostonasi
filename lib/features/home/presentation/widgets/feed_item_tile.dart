import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/abstract/feed_item.dart';

class FeedItemTile extends StatelessWidget {
  final FeedItem item;

  const FeedItemTile({super.key, required this.item});

  String getCreatedTime() {
    int days = item.createdAt.difference(DateTime.now()).inDays * (-1);
    int hours = item.createdAt.difference(DateTime.now()).inHours * (-1);
    int minutes = item.createdAt.difference(DateTime.now()).inMinutes * (-1);
    return days > 90
        ? 'ancha oldin'
        : days > 30
        ? '${days ~/ 30} oy oldin'
        : days > 0
        ? '$days kun oldin'
        : hours > 0
        ? '$hours soat oldin'
        : minutes > 30
        ? 'yarim soat oldin'
        : '$minutes daqiqa oldin';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
      child: Card(
        child:
            item.type == AppStrings.PIC_Firebase_model
                ? ListTile(
                  onTap: () {
                    context.push(AppRoutes.PicDetailPage, extra: item as Pic);
                  },
                  title: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: CachedNetworkImage(
                      imageUrl: item.content,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) {
                        return Center(
                          child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                        );
                      },
                      errorWidget:
                          (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  subtitle: _subtitle(context),
                )
                : ListTile(
                  onTap: () {
                    context.push(AppRoutes.PoemDetailPage, extra: item as Poem);
                  },
                  title:
                      item.title.length > 10
                          ? Text('${item.title.substring(0, 10)}...')
                          : Text(item.title),
                  subtitle: _subtitlePoem(context),
                ),
      ),
    );
  }

  Widget _likeButton(BuildContext context, bool isLiked) {
    final authState = context.read<AuthBloc>().state;

    return TextButton(
      onPressed: () {
        if (authState is Authenticated) {
          if (!isLiked) {
            context.read<HomeBloc>().add(LikeItem(item, authState.user.uid));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bu postni allaqachon yoqtirgansiz!'),
              ),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Yoqtirish uchun akkauntga kiring!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.LoginPage);
                    },
                    child: const Text(
                      'Kirish',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_outline_outlined,
            color: isLiked ? Colors.red : Colors.blueGrey,
            size: 20.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            item.likes.toString(),
            style: TextStyle(color: isLiked ? Colors.red : Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _subtitle(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.uid : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(child: Text(item.title)),
            if (userId != null)
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(AppStrings.USER_Firebase_model)
                        .doc(userId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return _likeButton(context, false);
                  }
                  final likedPosts = List<dynamic>.from(
                    (snapshot.data!.data()
                            as Map<String, dynamic>)['likedPosts'] ??
                        [],
                  );
                  final isLiked = likedPosts.contains(item.id);
                  return _likeButton(context, isLiked);
                },
              )
            else
              _likeButton(context, false),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text('Muallif: ${item.author}')),
            Text(getCreatedTime()),
          ],
        ),
      ],
    );
  }

  Widget _subtitlePoem(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.uid : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child:
                    item.content.length > 50
                        ? Text('${item.content.substring(0, 50)}...')
                        : Text(item.content),
              ),
            ),
            if (userId != null)
              StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(AppStrings.USER_Firebase_model)
                        .doc(userId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return _likeButton(context, false);
                  }
                  final likedPosts = List<dynamic>.from(
                    (snapshot.data!.data()
                            as Map<String, dynamic>)['likedPosts'] ??
                        [],
                  );
                  final isLiked = likedPosts.contains(item.id);
                  return _likeButton(context, isLiked);
                },
              )
            else
              _likeButton(context, false),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text('Muallif: ${item.author}')),
            Text(getCreatedTime()),
          ],
        ),
      ],
    );
  }
}
