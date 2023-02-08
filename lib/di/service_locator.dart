import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ufcat_ru_check/db/collections.dart';

class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._internal();

  ServiceLocator._internal();

  final GetIt _inject = GetIt.instance;

  static T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) =>
      instance._inject
          .get(instanceName: instanceName, param1: param1, param2: param2);

  static Future<void> initialize() {
    return instance._init();
  }

  Future<void> _init() async {
    await _initFirestore();
    _initCollections(get());
    _inject.registerSingleton(const FlutterSecureStorage());
    _inject.registerSingleton(IV.fromLength(16));
    _inject.registerSingleton(
        Encrypter(AES(Key.fromUtf8('my 32 length key................'))));
    await _initRepositories();
    _initUseCases();
    _initBlocs();
  }

  void _initBlocs() {}

  void _initUseCases() {}

  Future<void> _initFirestore() async {
    _inject.registerSingleton(FirebaseFirestore.instance);
    _inject.registerSingleton(FirebaseAuth.instance);
  }

  void _initCollections(FirebaseFirestore firestore) async {
    _inject.registerSingleton(firestore.students);
    _inject.registerSingleton(firestore.employees);
    _inject.registerSingleton(firestore.sheets);
    // await firestore.seedStudents();
    // await firestore.seedEmployees();
    // await firestore.seedSheets(daysAgo: 30);
  }

  Future<void> _initRepositories() async {}
}
