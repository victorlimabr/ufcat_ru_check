import 'package:flutter/foundation.dart';
import 'package:ufcat_ru_check/data/result.dart';

abstract class UseCase<I, T> {
  Future<T> perform(I input);

  @nonVirtual
  Stream<Result<T>> call(I input) async* {
    try {
      yield ResultLoading();
      final result = await perform(input);
      yield ResultSuccess(result);
    } on Exception catch (e) {
      yield ResultError(e);
    }
  }
}
