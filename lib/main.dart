import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/dashboard/dashboard_page.dart';
import 'package:ufcat_ru_check/feature/sign_in/sign_in_page.dart';
import 'package:ufcat_ru_check/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ServiceLocator.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
      ],
      theme: ThemeData(
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

      ),
      supportedLocales: const [Locale('en', ''), Locale('pt', '')],
      initialRoute: '/sign_in',
      routes: {
        '/sign_in': (_) => const SignInPage(),
        '/dashboard': (_) => const DashboardPage(),
      },
    );
  }
}
