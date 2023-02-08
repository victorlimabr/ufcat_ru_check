import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/db/dao.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee extends Entity<Employee> with Dao<Employee> {
  final String name;
  final String email;
  final String identifier;
  final String document;

  const Employee({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.email,
    required this.identifier,
    required this.document,
  });

  factory Employee.build({
    required String uid,
    required String name,
    required String email,
    required String identifier,
    required String document,
  }) {
    final now = DateTime.now();
    return Employee(
      id: uid,
      name: name,
      email: email,
      identifier: identifier,
      document: document,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  Employee copyWith({DateTime? createdAt, DateTime? updatedAt}) {
    return Employee(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name,
      email: email,
      identifier: identifier,
      document: document,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        email,
        identifier,
        document,
      ];
}

extension EmployeeFromJson on Map<String, dynamic> {
  Employee toEmployee() => _$EmployeeFromJson(this);
}
