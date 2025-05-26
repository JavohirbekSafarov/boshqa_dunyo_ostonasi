import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/presentation/pages/pic_detail_page.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/presentation/pages/poem_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

final _auth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.HomePage,
  redirect: (context, state) {
    final user = _auth.currentUser;
    final goingToLogin = state.matchedLocation == AppRoutes.LoginPage;
    if (user == null && !goingToLogin) {
      return AppRoutes.LoginPage;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.HomePage,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.LoginPage,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.PicDetailPage,
      builder: (context, state) {
        final pic = state.extra as Pic;
        return PicDetailPage(pic: pic);
      },
    ),
    GoRoute(
      path: AppRoutes.PoemDetailPage,
      builder: (context, state) {
        final poem = state.extra as Poem;
        return PoemDetailPage(poem: poem);
      },
    ),
    /* GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),*/
    // Qo‘shimcha: /poems, /pics, /shop, /poem/:id, /pic/:id va hokazo
  ],
);
