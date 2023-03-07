import 'package:formz/formz.dart';

enum PasswordError { short }

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordError? validator(String value) {
    return value.length >= 6 ? null : PasswordError.short;
  }
}
