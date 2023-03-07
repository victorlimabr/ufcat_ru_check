import 'package:flutter/foundation.dart';
import 'package:ufcat_ru_check/data/result.dart';

abstract class FutureUseCase<I, T> {
  Future<T> perform(I input);

  @nonVirtual
  Future<Result<T>> call(I input) async {
    try {
      final result = await perform(input);
      if (isResultEmpty(result)) {
        return ResultEmpty();
      }
      return ResultSuccess(result);
    } on Exception catch (e) {
      return ResultError(e);
    }
  }

  bool isResultEmpty(T result) => false;
}

abstract class StreamUseCase<I, T> {
  Stream<T> perform(I input);

  @nonVirtual
  Stream<Result<T>> call(I input) {
    return perform(input).map((event) {
      if (isEventEmpty(event)) {
        return ResultEmpty<T>();
      }
      return ResultSuccess(event);
    }).handleError((e, stack) {
      debugPrintStack(stackTrace: stack, label: e.toString());
      ResultError(Exception(e.toString()));
    });
  }

  bool isEventEmpty(T empty) => false;
}
