import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ufcat_ru_check/utils/firestore_utils.dart';

abstract class Entity<T> extends Equatable {
  final String id;
  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime updatedAt;

  const Entity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  T created({DateTime? at}) {
    final date = at ?? DateTime.now();
    return copyWith(createdAt: date, updatedAt: date);
  }

  T updated({DateTime? at}) => copyWith(updatedAt: at ?? DateTime.now());

  T copyWith({DateTime? createdAt, DateTime? updatedAt});

  Map<String, dynamic> toJson();

  @override
  @mustCallSuper
  List<Object?> get props => [id, createdAt, updatedAt];
}
