import 'package:formz/formz.dart';

enum EmailError { invalid }

class Email extends FormzInput<String, EmailError> {
  const Email.pure() : super.pure('');

  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailError? validator(String value) {
    return null;
  }
}
