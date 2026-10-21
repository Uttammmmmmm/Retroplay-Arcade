import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'core/storage/local_game_storage.dart';
import 'features/home/presentation/home_screen.dart';

class RetroPlayApp extends StatelessWidget {
  const RetroPlayApp({super.key, required this.prefs});
  final dynamic prefs;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RetroPlay Arcade',
    debugShowCheckedModeBanner: false,
    theme: retroTheme,
    home: HomeScreen(storage: LocalGameStorage(prefs)),
  );
}
