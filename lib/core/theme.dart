import 'package:flutter/material.dart';

const retroBg = Color(0xFF100F24);
const retroSurface = Color(0xFF1D1B3A);
const retroRaised = Color(0xFF29264B);
const retroCyan = Color(0xFF35E0D0);
const retroYellow = Color(0xFFFFD166);
const retroPurple = Color(0xFF8B72FF);
const retroText = Color(0xFFF8F7FF);
const retroMuted = Color(0xFFB9B6D6);
const retroDanger = Color(0xFFFF6B7A);

final retroTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: retroBg,
  colorScheme: const ColorScheme.dark(
    primary: retroCyan,
    secondary: retroYellow,
    surface: retroSurface,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: retroBg,
    foregroundColor: retroText,
    elevation: 0,
  ),
  useMaterial3: true,
);
