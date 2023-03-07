import 'package:ufcat_ru_check/data/setting/app_settings.dart';

class AppSettingsState {
  final AppSettings settings;
  final bool saved;

  const AppSettingsState({
    required this.settings,
    this.saved = false,
  });

  factory AppSettingsState.initial() => AppSettingsState(
        settings: AppSettings.empty(),
      );

  AppSettingsState copyWith({AppSettings? settings, bool? saved}) {
    return AppSettingsState(
      settings: settings ?? this.settings,
      saved: saved ?? this.saved,
    );
  }
}
