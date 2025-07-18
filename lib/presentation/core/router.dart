import 'package:go_router/go_router.dart';
import 'package:yono_bakrie_app/presentation/screens/splash_screen.dart';
import 'package:yono_bakrie_app/presentation/screens/login_screen.dart';

class MyRouter {
  static String splash = "/";
  static String login = "/login";
  static String userDetail = "/user-detail";

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, state) => const LoginScreen(),
      ),
    ],
  );
}
