import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/authentication/authentication_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/dashboard_page.dart';
import 'package:ufcat_ru_check/feature/navigator.dart';
import 'package:ufcat_ru_check/feature/sign_in/sign_in_page.dart';
import 'package:ufcat_ru_check/ui/design_system.dart';

void main() async {
  await ServiceLocator.initialize();
  runApp(
    BlocProvider(
      create: (_) => ServiceLocator.get<AuthenticationBloc>(),
      child: const UfcatRuCheckApp(),
    ),
  );
}

class UfcatRuCheckApp extends StatefulWidget {
  const UfcatRuCheckApp({super.key});

  @override
  State<UfcatRuCheckApp> createState() => _UfcatRuCheckAppState();
}

class _UfcatRuCheckAppState extends State<UfcatRuCheckApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: DesignSystem.theme,
      supportedLocales: const [Locale('en', ''), Locale('pt', '')],
      initialRoute: '/sign_in',
      builder: (context, child) =>
          BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          final employee = state.employee;
          if (employee == null) {
            _navigator.navigateFade(to: const SignInPage(), root: true);
          } else {
            _navigator.navigateFade(to: const DashboardPage(), root: true);
          }
        },
        child: child,
      ),
      routes: {
        '/sign_in': (_) => const SignInPage(),
        '/dashboard': (_) => const DashboardPage(),
      },
    );
  }
}
