import 'package:go_router/go_router.dart';
import 'package:yb_management/presentation/screens/splash_screen.dart';
import 'package:yb_management/presentation/screens/login_screen.dart';
import 'package:yb_management/presentation/screens/home_screen.dart';
import 'package:yb_management/presentation/screens/phase_list_screen.dart';
import 'package:yb_management/presentation/screens/category_list_screen.dart';
import 'package:yb_management/presentation/screens/show_detail_page.dart';
import 'package:yb_management/presentation/screens/purchased_tickets_page.dart';
import 'package:yb_management/domain/entities/show_entity.dart';

class MyRouter {
  static String splash = "/";
  static String login = "/login";
  static String home = "/home";
  static String userDetail = "/user-detail";
  static String showDetail = "/show-detail";

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, state) => const HomeScreen()),
      GoRoute(path: '/phases', builder: (_, state) => const PhaseListScreen()),
      GoRoute(
        path: '/categories',
        builder: (_, state) => const CategoryListScreen(),
      ),
      GoRoute(
        path: '/show-detail',
        builder: (_, state) {
          final show = state.extra as ShowEntity;
          return ShowDetailPage(show: show);
        },
      ),
      GoRoute(
        path: '/purchased-tickets/:showId',
        builder: (_, state) {
          final show = state.extra as ShowEntity;
          return PurchasedTicketsPage(show: show);
        },
      ),
    ],
  );
}
