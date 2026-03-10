import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/routing/app_router.dart';

class App extends ConsumerWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FSP Starter',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      routerConfig: buildRouter(initialRoute, ref),
      debugShowCheckedModeBanner: false,
    );
  }
}