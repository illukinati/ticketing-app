import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_management/presentation/core/router.dart';
import 'package:yb_management/presentation/core/theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yono Bakrie App',
      routerConfig: MyRouter.router,
      theme: ValentineTheme.lightTheme,
      darkTheme: ValentineTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
