import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.g.dart';

class AuthException implements Exception {
  final AuthExceptionError error;

  AuthException({this.error = AuthExceptionError.other});
}

class UnauthorizedException extends AuthException {
  UnauthorizedException({super.error});
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum AuthExceptionError {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  weakPassword,
  other;

  static AuthExceptionError fromString(String code) =>
      _$AuthExceptionErrorEnumMap.entries
          .firstWhereOrNull((e) => e.value == code)
          ?.key ??
      other;
}

extension FirebaseException on FirebaseAuthException {
  AuthException toAppException() {
    return AuthException(error: AuthExceptionError.fromString(code));
  }
}
