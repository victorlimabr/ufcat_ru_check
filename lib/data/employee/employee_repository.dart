import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/infra/db/dao.dart';

class EmployeeDao extends Dao<Employee> {
  EmployeeDao(super.collection);
}
