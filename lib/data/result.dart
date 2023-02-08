import 'package:freezed_annotation/freezed_annotation.dart';

@sealed
abstract class Result<T> {

}

class ResultEmpty<T> extends Result<T> {

}

class ResultLoading<T> extends Result<T> {

}

class ResultError<T> extends Result<T> {
  final Exception? exception;

  ResultError(this.exception);
}

class ResultSuccess<T> extends Result<T> {
  final T data;

  ResultSuccess(this.data);
}