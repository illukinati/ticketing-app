import 'package:go_router/go_router.dart';
import 'package:yono_bakrie_app/presentation/screens/splash_screen.dart';
import 'package:yono_bakrie_app/presentation/screens/login_screen.dart';
import 'package:yono_bakrie_app/presentation/screens/home_screen.dart';
import 'package:yono_bakrie_app/presentation/screens/phase_list_screen.dart';
import 'package:yono_bakrie_app/presentation/screens/category_list_screen.dart';

class MyRouter {
  static String splash = "/";
  static String login = "/login";
  static String home = "/home";
  static String userDetail = "/user-detail";

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
    ],
  );
}
