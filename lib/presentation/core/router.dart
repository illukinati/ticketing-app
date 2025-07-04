import 'package:go_router/go_router.dart';
import 'package:yono_bakrie_app/presentation/screens/splash_screen.dart';

class MyRouter {
  static String userDetail = "/user-detail";

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (_, state) => const SplashScreen())],
  );
}
