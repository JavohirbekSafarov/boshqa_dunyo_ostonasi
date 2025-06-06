import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/home/presentation/bloc/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.read<AuthBloc>().state is Authenticated;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        title: Text(widget.pic.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.favorite_border, color: _isLiked ? Colors.red : Colors.white),
              onPressed: () {
                if (!_isLiked) {
                  context.read<HomeBloc>().add(LikeItem(widget.pic));
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yoqtirilgan!')));
                }
              },
            )
          else
            IconButton(
              icon: Icon(LineIcons.doorClosed, color: Colors.white),
              onPressed: () => context.go(AppRoutes.LoginPage),
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
                      child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.blueGrey),
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
