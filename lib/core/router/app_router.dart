import 'package:boshqa_dunyo_ostonasi/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

final _auth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes().HomePage,
  redirect: (context, state) {
    final user = _auth.currentUser;
    final goingToLogin = state.matchedLocation == AppRoutes().LoginPage;
    if (user == null && !goingToLogin) {
      return AppRoutes().LoginPage;
    }
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes().HomePage, builder: (context, state) => const HomePage()),
    GoRoute(path: AppRoutes().LoginPage, builder: (context, state) => LoginPage()),
    /* GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),*/
    // Qo‘shimcha: /poems, /pics, /shop, /poem/:id, /pic/:id va hokazo
  ],
);
