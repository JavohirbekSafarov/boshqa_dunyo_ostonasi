import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/core/constants/app_strings.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/pic.dart';

class PicDetailPage extends StatefulWidget {
  final Pic pic;

  const PicDetailPage({super.key, required this.pic});

  @override
  State<PicDetailPage> createState() => _PicDetailPageState();
}

class _PicDetailPageState extends State<PicDetailPage> {

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.uid : null;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        title: Text(
          widget.pic.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          userId != null
              ? StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(AppStrings.USER_Firebase_model)
                        .doc(userId)
                        .snapshots(),
                builder: (context, snapshot) {
                  bool isLiked = false;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final likedPosts = List<dynamic>.from(
                      (snapshot.data!.data()
                              as Map<String, dynamic>)['likedPosts'] ??
                          [],
                    );
                    isLiked = likedPosts.contains(widget.pic.id);
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
                            LikeItem(widget.pic, userId),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bu rasm allaqachon yoqtirilgan!'),
                            ),
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
                icon: const Icon(LineIcons.doorClosed, color: Colors.white,),
              ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5, // Minimal yaqinlashuv darajasi
          maxScale: 4.0, // Maksimal yaqinlashuv darajasi
          child: SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl: widget.pic.content,
              progressIndicatorBuilder:
                  (context, url, downloadProgress) => Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          ),
        ),
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
