import 'package:flutter/material.dart';

class DesignSystem {
  const DesignSystem._();

  static InputDecoration get inputDecoration => const InputDecoration(
        border: OutlineInputBorder(),
      );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.deepPurple.shade100,
        cardTheme: CardTheme(
          color: Colors.deepPurple.shade50,
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          indicatorColor: Colors.deepPurple.shade100,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.deepPurple.shade50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          indent: 12,
          endIndent: 12,
        ),
      );
}
