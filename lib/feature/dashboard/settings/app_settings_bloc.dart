import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufcat_ru_check/data/setting/app_settings_repository.dart';
import 'package:ufcat_ru_check/data/setting/income_range_settings.dart';
import 'package:ufcat_ru_check/data/setting/report_settings.dart';
import 'package:ufcat_ru_check/data/setting/sheet_settings.dart';
import 'package:ufcat_ru_check/data/setting/subsidy_settings.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_state.dart';

class AppSettingsBloc extends Cubit<AppSettingsState> {
  final AppSettingsDao _settingsRepository;

  AppSettingsBloc(this._settingsRepository) : super(AppSettingsState.initial());

  void loadSettings() async {
    final settings = await _settingsRepository.findAll();
    if (settings.isNotEmpty) {
      emit(state.copyWith(settings: settings.first, saved: true));
    }
  }

  void saveSettings() async {
    await _settingsRepository.save(state.settings);
    emit(state.copyWith(saved: true));
  }

  void _changeSheetSettings(SheetSettings sheetSettings) {
    final settings = state.settings.copyWith(sheetSettings: sheetSettings);
    emit(state.copyWith(settings: settings, saved: false));
  }

  void changeRegisterColumn(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      registerColumn: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void changeNameColumn(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      nameColumn: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void changeTimeColumn(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      timeColumn: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void changeStatusColumn(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      statusColumn: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void changeFirstEntryLine(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      firstEntryLine: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void changeFooterLineCount(String value) {
    final sheetSettings = state.settings.sheetSettings.copyWith(
      footerLineCount: int.tryParse(value),
    );
    _changeSheetSettings(sheetSettings);
  }

  void _changeSubsidySettings(SubsidySettings subsidySettings) {
    final settings = state.settings.copyWith(subsidySettings: subsidySettings);
    emit(state.copyWith(settings: settings, saved: false));
  }

  void changeFullCost(String value) {
    final subsidySettings = state.settings.subsidySettings.copyWith(
      fullCost: Decimal.tryParse(value),
    );
    _changeSubsidySettings(subsidySettings);
  }

  void changeLowSubsidy(String value) {
    final subsidySettings = state.settings.subsidySettings.copyWith(
      lowSubsidy: Decimal.tryParse(value),
    );
    _changeSubsidySettings(subsidySettings);
  }

  void changeHighSubsidy(String value) {
    final subsidySettings = state.settings.subsidySettings.copyWith(
      highSubsidy: Decimal.tryParse(value),
    );
    _changeSubsidySettings(subsidySettings);
  }

  void _changeIncomeSettings(IncomeRangeSettings incomeSettings) {
    final settings = state.settings.copyWith(incomeSettings: incomeSettings);
    emit(state.copyWith(settings: settings, saved: false));
  }

  void changeFreeLimit(String value) {
    final incomeSettings = state.settings.incomeSettings.copyWith(
      freeLimit: Decimal.tryParse(value),
    );
    _changeIncomeSettings(incomeSettings);
  }

  void changeLowLimit(String value) {
    final incomeSettings = state.settings.incomeSettings.copyWith(
      lowLimit: Decimal.tryParse(value),
    );
    _changeIncomeSettings(incomeSettings);
  }

  void changeHighLimit(String value) {
    final incomeSettings = state.settings.incomeSettings.copyWith(
      highLimit: Decimal.tryParse(value),
    );
    _changeIncomeSettings(incomeSettings);
  }

  void _changeReportSettings(ReportSettings reportSettings) {
    final settings = state.settings.copyWith(reportSettings: reportSettings);
    emit(state.copyWith(settings: settings, saved: false));
  }

  void changeStudentUpdateTimeout(String value) {
    final reportSettings = state.settings.reportSettings.copyWith(
      studentUpdateTimeoutInDays: int.tryParse(value),
    );
    _changeReportSettings(reportSettings);
  }
}
