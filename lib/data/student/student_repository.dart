import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/infra/db/dao.dart';

class StudentDao extends Dao<Student> {
  StudentDao(super.collection);

}