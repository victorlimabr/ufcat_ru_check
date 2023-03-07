import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:get_it/get_it.dart';
import 'package:ufcat_ru_check/data/employee/employee_repository.dart';
import 'package:ufcat_ru_check/data/seed.dart';
import 'package:ufcat_ru_check/data/setting/app_settings_repository.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student_repository.dart';
import 'package:ufcat_ru_check/domain/auth/auth_check_use_case.dart';
import 'package:ufcat_ru_check/domain/user/delete_user_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_in_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_out_use_case.dart';
import 'package:ufcat_ru_check/domain/auth/sign_up_use_case.dart';
import 'package:ufcat_ru_check/domain/report/check_invalid_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/check_irregular_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/check_out_of_range_students_use_case.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_category.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_level.dart';
import 'package:ufcat_ru_check/domain/report/get_entries_by_meal.dart';
import 'package:ufcat_ru_check/domain/report/get_meal_costs_use_case.dart';
import 'package:ufcat_ru_check/domain/user/get_current_employee_use_case.dart';
import 'package:ufcat_ru_check/domain/user/listen_current_employee_use_case.dart';
import 'package:ufcat_ru_check/domain/user/update_user_password_use_case.dart';
import 'package:ufcat_ru_check/feature/authentication/authentication_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/daily/daily_entries_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/employee_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/employee/user_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/entries_filter/entries_filter_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/report/entries_report_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/settings/app_settings_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/students/students_bloc.dart';
import 'package:ufcat_ru_check/feature/sign_in/sign_in_bloc.dart';
import 'package:ufcat_ru_check/feature/sign_up/sign_up_bloc.dart';
import 'package:ufcat_ru_check/infra/db/collections.dart';
import 'package:ufcat_ru_check/services/sheet_parser.dart';
import 'package:ufcat_ru_check/utils/app_constants.dart';

/// Componente que encapsula as dependências do projeto. Para que os componentes
/// da aplicação possam acessar essas dependências.
class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._internal();

  ServiceLocator._internal();

  final GetIt _inject = GetIt.instance;

  static T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) =>
      instance._inject.get(
        instanceName: instanceName,
        param1: param1,
        param2: param2,
      );

  static Future<void> initialize({bool production = true}) {
    return instance._init(production);
  }

  Future<void> _init(bool production) async {
    _registerEnvironment(production);
    _registerSecurity(get());
    await _registerFirebase();
    _registerCollections(get());
    await _registerDAOs(seed: false);
    _inject.registerFactory(() => SheetParser(get()));
    _registerUseCase();
    _initBlocs();
  }

  /// Registra as veriáveis de ambiente
  void _registerEnvironment(bool production) {
    final constants = AppConstants.instanceBy(production);
    _inject.registerSingleton(constants);
    _inject.registerSingleton(constants.firebaseOptions);
  }

  /// Não implementado
  void _registerSecurity(AppConstants constants) {
    // final encrypter = Encrypter(AES(Key.fromUtf8(constants.aesKey)));
    // _inject.registerSingleton(encrypter);
    // _inject.registerSingleton(IV.fromLength(16));
    // _inject.registerSingleton(const FlutterSecureStorage());
  }

  Future<void> _registerFirebase() async {
    _inject.registerSingleton(FirebasePlatform.instance);
    await ServiceLocator.get<FirebasePlatform>().initializeApp(
      options: ServiceLocator.get(),
    );
    _inject.registerSingleton(FirebaseFirestore.instance);
    _inject.registerSingleton(FirebaseAuth.instance);
  }

  /// Registra as coleções do banco de dados
  void _registerCollections(FirebaseFirestore firestore) async {
    _inject.registerSingleton(firestore.students);
    _inject.registerSingleton(firestore.employees);
    _inject.registerSingleton(firestore.sheets);
    _inject.registerSingleton(firestore.appSettings);
  }

  Future<void> _registerDAOs({bool seed = false}) async {
    _inject.registerFactory(() => EmployeeDao(get()));
    _inject.registerFactory(() => StudentDao(get()));
    _inject.registerFactory(() => SheetDao(get()));
    _inject.registerFactory(() => AppSettingsDao(get()));
    if (seed) {
      final settings = await _inject<AppSettingsDao>().findAll();
      if (settings.isNotEmpty) {
        final students = await get<StudentDao>().seedStudents(
          amount: 40,
          settings: settings.first.incomeSettings,
        );
        // final employees = await get<EmployeeRepository>().seedEmployees();
        // await get<SheetRepository>().seedSheets(
        //   daysAgo: 30,
        //   students: students,
        //   employees: employees,
        // );
      }
    }
  }

  void _registerUseCase() {
    _inject.registerFactory(() => ListenCurrentEmployeeUseCase(get(), get()));
    _inject.registerFactory(() => GetCurrentEmployeeUseCase(get(), get()));
    _inject.registerFactory(() => AuthCheckUseCase(get(), get()));
    _inject.registerFactory(() => SignInUseCase(get(), get()));
    _inject.registerFactory(() => SignUpUseCase(get(), get()));
    _inject.registerFactory(() => SignOutUseCase(get()));
    _inject.registerFactory(() => UpdateUserPasswordUseCase(get()));
    _inject.registerFactory(() => DeleteUserUseCase(get(), get()));
    // Casos de usos do relatorio
    _inject.registerFactory(() => CheckInvalidStudentsUseCase(get(), get()));
    _inject.registerFactory(() => CheckIrregularStudentsUseCase(get(), get()));
    _inject.registerFactory(() => CheckOutOfRangeStudentsUseCase(get(), get()));
    _inject.registerFactory(() => GetMealCostsUseCase(get()));
    _inject.registerFactory(() => GetEntriesByCategory(get()));
    _inject.registerFactory(() => GetEntriesByLevel(get()));
    _inject.registerFactory(() => GetEntriesByMeal(get()));
  }

  /// Registra os gerenciadores de estado da aplicação
  void _initBlocs() {
    _inject.registerFactory(() => AuthenticationBloc(get(), get()));
    _inject.registerFactory(() => SignInBLoC(get(), get()));
    _inject.registerFactory(() => SignUpBLoC(get()));
    _inject.registerFactory(() => AppSettingsBloc(get()));
    _inject.registerFactory(() => EntriesFilterBloc(get()));
    _inject.registerFactory(() => DailyEntriesBloc(get()));
    _inject.registerFactory(() => EntriesReportBLoC(
        get(), get(), get(), get(), get(), get(), get(), get()));
    _inject.registerFactory(() => StudentsBloc(get()));
    _inject.registerFactory(() => EmployeeBloc(get()));
    _inject.registerFactory(() => UserBloc(get(), get()));
  }
}
