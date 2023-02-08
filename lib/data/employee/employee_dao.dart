import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/db/dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';

class EmployeeEntity {
  const EmployeeEntity._();

  static CollectionReference<Employee> get _collection =>
      ServiceLocator.get<CollectionReference<Employee>>();

  static Future<Employee?> find(String id) async {
    return _collection.find(id);
  }
}
