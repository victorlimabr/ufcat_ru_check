import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {

}

class InvalidEmailException implements AuthException {

}

class UserDisabledException implements AuthException {

}

class UserNotFoundException implements AuthException {

}

class WrongPasswordException implements AuthException {

}

class EmailAlreadyInUseException implements AuthException {

}

class WeakPasswordException implements AuthException {

}

class UnauthorizedException implements AuthException {

}

extension FirebaseException on FirebaseAuthException {
  AuthException toAppException() {
    switch (code) {
      case 'invalid-email':
        return InvalidEmailException();
      case 'user-disabled':
        return UserDisabledException();
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return WrongPasswordException();
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'weak-password':
        return EmailAlreadyInUseException();
      default:
        return AuthException();
    }
  }
}