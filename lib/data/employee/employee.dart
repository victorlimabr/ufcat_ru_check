import 'package:json_annotation/json_annotation.dart';
import 'package:ufcat_ru_check/data/entity.dart';
import 'package:ufcat_ru_check/data/auto_id_generator.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee extends Entity<Employee> {
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
    required String id,
    required String name,
    required String email,
    required String identifier,
    required String document,
  }) {
    final now = DateTime.now();
    return Employee(
      id: id,
      name: name,
      email: email,
      identifier: identifier,
      document: document,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Employee.empty() {
    return Employee.build(
      id: AutoIdGenerator.autoId(),
      name: '',
      email: '',
      identifier: '',
      document: '',
    );
  }

  @override
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  Employee copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? email,
    String? identifier,
    String? document,
  }) {
    return Employee(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      identifier: identifier ?? this.identifier,
      document: document ?? this.document,
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
