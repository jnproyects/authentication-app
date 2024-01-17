import 'package:authentication_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:authentication_app/config/config.dart';

void main() async {

  await Environment.initEnvironment();
  
  runApp(
    const ProviderScope(
      child: MainApp()
    )
  );

}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build( BuildContext context, WidgetRef ref ) {

    final appRouter = ref.watch( goRouterProvider );
    final bool isDarkMode = ref.watch( darkModeProvider );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme( isDarkmode: isDarkMode ).getTheme(),
    );

  }
}
