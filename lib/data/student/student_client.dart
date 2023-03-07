import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/infra/remote/apis/sigaa_client.dart';

class StudentClient extends SigaaClient {
  StudentClient(
    super.client,
    super.connectivity,
    super.secureStorage,
    super.constants,
  ) : super(endpoint: 'students');

  Stream<Result<SigaaResource<List<Student>>>> getStudents() {
    return get('', (body) => body.toStudents());
  }
}

extension on String {
  SigaaResource<List<Student>> toStudents() => SigaaResource.fromBody(
        this,
        (map) => (map as List<dynamic>).toStudents(),
      );
}

extension on List<dynamic> {
  List<Student> toStudents() =>
      map((e) => (e as Map<String, dynamic>).toStudent()).toList();
}
