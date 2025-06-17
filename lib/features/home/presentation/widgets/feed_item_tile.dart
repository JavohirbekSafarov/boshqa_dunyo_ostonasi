import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return days > 30
        ? '${days ~/ 30} oy oldin'
        : days > 0
        ? '$days kun oldin'
        : hours > 0
        ? '$hours soat oldin'
        : '$minutes daqiqa oldin';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
      child: Card(
        child:
            item.type == AppStrings.PIC_Firebase_model
                ? ListTile(
                  onTap: () {
                    context.push(AppRoutes.PicDetailPage, extra: item as Pic);
                  },
                  title: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: CachedNetworkImage(
                      imageUrl: item.content,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) {
                        return Center(
                          child: SizedBox(height: 50.0, width: 50.0, child: Image.asset('assets/images/loading.gif')),
                        );
                      },
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  subtitle: _subtitle(context),
                )
                : ListTile(
                  onTap: () {
                    context.push(AppRoutes.PoemDetailPage, extra: item as Poem);
                  },
                  title: item.title.length > 10 ? Text('${item.title.substring(0, 10)}...') : Text(item.title),
                  subtitle: _subtitlePoem(context),
                ),
      ),
    );
  }

  Widget _likeButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AuthBloc>().state is Authenticated
            ? context.read<HomeBloc>().add(LikeItem(item))
            : showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Yoqtirish uchun akkauntga kiring!', style: TextStyle(fontSize: 18)),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.LoginPage);
                      },
                      child: Text('Kirish', style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('Ok', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              },
            );
      },
      child: Row(children: [Icon(Icons.favorite, color: Colors.blueGrey), Text(item.likes.toString())]),
    );
  }

  Widget _subtitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(children: [Expanded(child: Text(item.title)), _likeButton(context)]),
        Row(children: [Expanded(child: Text('Author: ${item.author}')), Text(getCreatedTime())]),
      ],
    );
  }

  Widget _subtitlePoem(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: item.content.length > 50 ? Text('${item.content.substring(0, 50)}...') : Text(item.content),
              ),
            ),
            _likeButton(context),
          ],
        ),
        Row(children: [Expanded(child: Text('Author: ${item.author}')), Text(getCreatedTime())]),
      ],
    );
  }
}
