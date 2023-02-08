import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension TextSylesContext on BuildContext {
  TextStyle? get displayLarge => theme.textTheme.displayLarge;

  TextStyle? get titleMedium => theme.textTheme.titleMedium;

  TextStyle? get bodyLarge => theme.textTheme.bodyLarge;

  TextStyle? get bodyMedium => theme.textTheme.bodyMedium;

  TextStyle? get labelLarge => theme.textTheme.labelLarge;
}

extension ColorsContext on BuildContext {
  Color? get cardColor => theme.cardTheme.color ?? theme.cardColor;

  Color get scaffoldColor => theme.scaffoldBackgroundColor;
}
