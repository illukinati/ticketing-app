import 'package:flutter/material.dart';
import 'package:yono_bakrie_app/presentation/core/router.dart';
import 'package:yono_bakrie_app/presentation/core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yono Bakrie App',
      routerConfig: MyRouter.router,
      theme: ValentineTheme.lightTheme,
      darkTheme: ValentineTheme.lightTheme,
      themeMode: ThemeMode.system,
    );
  }
}
