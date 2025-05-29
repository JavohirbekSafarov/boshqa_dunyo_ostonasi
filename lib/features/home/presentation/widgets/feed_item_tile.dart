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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      child: Card(
        child:
            item.type == AppStrings.PIC
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
                          child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/loading.gif'),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  // FadeInImage.assetNetwork(
                  //   placeholder: 'assets/images/loading.gif',
                  //   image: item.content,
                  //   height: 200,
                  //   width: 300,
                  // ),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text('Author: ${item.author}')),
                      _likeButton(context),
                    ],
                  ),
                )
                : ListTile(
                  onTap: () {
                    context.push(AppRoutes.PoemDetailPage, extra: item as Poem);
                  },
                  title: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child:
                        item.content.length > 30
                            ? Text('${item.content.substring(0, 30)}...')
                            : Text(item.content),
                  ),

                  subtitle: Row(
                    children: [
                      Expanded(child: Text('Author: ${item.author}')),
                      _likeButton(context),
                    ],
                  ),
                ),
      ),
    );
    // return Card(
    //   child: ListTile(
    //     leading:
    //         item.type == 'pic'
    //             ? Image.network(
    //               item.content,
    //               width: 100,
    //               height: 100,
    //               fit: BoxFit.cover,
    //             )
    //             : const Icon(Icons.text_snippet_rounded),
    //     title: Column(
    //       children: [
    //         Image.network(
    //           item.content,
    //           width: 100,
    //           height: 100,
    //           fit: BoxFit.cover,
    //         ),
    //         Text(item.type == 'poem' ? item.content.split('\n').first : 'Rasm'),
    //       ],
    //     ),
    //     subtitle: Text("Muallif: ${item.author} • 👍 ${item.likes}"),
    //     onTap: () {
    //       context.push(
    //         '/${item.type}/${item.id}',
    //       ); // Masalan: /poem/1 yoki /pic/2
    //     },
    //   ),
    // );
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
                  title: Text('Yoqtirish uchun akkauntga kiring!'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.LoginPage);
                      },
                      child: Text('Kirish'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
      },
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.blueGrey),
          Text(item.likes.toString()),
        ],
      ),
    );
  }
}
