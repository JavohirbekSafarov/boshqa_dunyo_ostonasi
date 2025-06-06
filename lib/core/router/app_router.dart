import 'package:boshqa_dunyo_ostonasi/core/constants/app_routes.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/domain/entities/pic.dart';
import 'package:boshqa_dunyo_ostonasi/features/pic/presentation/pages/pic_detail_page.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/domain/entities/poem.dart';
import 'package:boshqa_dunyo_ostonasi/features/poem/presentation/pages/poem_detail_page.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/pages/book_detail_page.dart';
import 'package:boshqa_dunyo_ostonasi/features/shop/presentation/pages/upload_book_page.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/shop/data/enties/book_model.dart';
import '../../features/upload/presentation/pages/upload_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shop/presentation/pages/shop_page.dart';
import '../widgets/main_scaffold.dart';

final _auth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.HomePage,
  redirect: (context, state) {
    final user = _auth.currentUser;
    final goingToLogin = state.matchedLocation == AppRoutes.HomePage;
    if (user == null && !goingToLogin) {
      return AppRoutes.LoginPage;
    }
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.HomePage,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.UploadPage,
          builder: (context, state) => const UploadPage(),
        ),
        GoRoute(
          path: AppRoutes.ProfilePage,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.ShopPage,
      builder: (context, state) => const ShopPage(),
    ),
    GoRoute(
      path: AppRoutes.LoginPage,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.BookUploadPage,
      builder: (context, state) => UploadBookPage(),
    ),
    GoRoute(
      path: AppRoutes.BookDetailPage,
      builder: (context, state){
        final book = state.extra as Book;
        return BookDetailPage(book: book);
      },
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
  ],
);
