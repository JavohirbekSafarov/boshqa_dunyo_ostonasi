import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/abstract/feed_item.dart';

class FeedItemTile extends StatelessWidget {
  final FeedItem item;

  const FeedItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child:
            item.type == AppStrings.PIC
                ? ListTile(
                  onTap: () {
                    context.push(AppRoutes.PicDetailPage, extra: item as Pic);
                  },
                  title: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: item.content,
                    height: 200,
                    width: 300,
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text('Author: ${item.author}')),
                      TextButton(
                        onPressed: () {
                          print('Like clicked!');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red),
                            Text(item.likes.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : ListTile(
                  onTap: () {
                    context.push(AppRoutes.PoemDetailPage, extra: item as Poem);
                  },
                  title: Text(item.content),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text('Author: ${item.author}')),
                      TextButton(
                        onPressed: () {
                          print('Like clicked!');
                        },
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red),
                            Text(item.likes.toString()),
                          ],
                        ),
                      ),
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
}
