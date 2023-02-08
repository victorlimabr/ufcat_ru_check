import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/student/student.dart';

extension Collections on FirebaseFirestore {
  CollectionReference<Sheet> get sheets => collection('sheet').withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!.toSheet(),
        toFirestore: (value, _) => value.toJson(),
      );

  CollectionReference<Student> get students =>
      collection('student').withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!.toStudent(),
        toFirestore: (value, _) => value.toJson(),
      );

  CollectionReference<Employee> get employees =>
      collection('employee').withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!.toEmployee(),
        toFirestore: (value, _) => value.toJson(),
      );
}
