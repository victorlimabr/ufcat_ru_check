import 'package:firebase_core/firebase_core.dart';

abstract class AppConstants {
  String get sigaaBaseUrl;

  String get aesKey;

  _FirebaseConstants get _firebaseConstants;

  FirebaseOptions get firebaseOptions => FirebaseOptions(
        apiKey: _firebaseConstants.apiKey,
        appId: _firebaseConstants.appId,
        messagingSenderId: _firebaseConstants.messagingSenderId,
        projectId: _firebaseConstants.projectId,
        authDomain: _firebaseConstants.authDomain,
        storageBucket: _firebaseConstants.storageBucket,
        measurementId: _firebaseConstants.measurementId,
      );

  static AppConstants instanceBy(bool production) {
    if (production) return ProductionAppConstants();
    return StagingAppConstants();
  }
}

abstract class _FirebaseConstants {
  String get apiKey => 'AIzaSyBkXWejnyEtuD2o_pidrbyJOWbTTuXWLcQ';

  String get appId => '1:700399273409:web:1ee911262fd10f8a591b40';

  String get projectId => 'ufcat-ru-check';

  String get messagingSenderId;

  String get authDomain;

  String get storageBucket;

  String get measurementId;
}

class _StagingFirebaseConstants extends _FirebaseConstants {
  @override
  String get messagingSenderId => '700399273409';

  @override
  String get authDomain => 'ufcat-ru-check.firebaseapp.com';

  @override
  String get storageBucket => 'ufcat-ru-check.appspot.com';

  @override
  String get measurementId => 'G-WWCPK70P2E';
}

class _ProductionFirebaseConstants extends _FirebaseConstants {
  @override
  String get messagingSenderId => '700399273409';

  @override
  String get authDomain => 'ufcat-ru-check.firebaseapp.com';

  @override
  String get storageBucket => 'ufcat-ru-check.appspot.com';

  @override
  String get measurementId => 'G-WWCPK70P2E';
}

class StagingAppConstants extends AppConstants {
  @override
  String get sigaaBaseUrl => 'https://sigaa.sistemas.ufg.br/api';

  @override
  String get aesKey => 'my 32 length key................';

  @override
  _FirebaseConstants get _firebaseConstants => _StagingFirebaseConstants();
}

class ProductionAppConstants extends AppConstants {
  @override
  String get sigaaBaseUrl => 'https://sigaa.sistemas.ufg.br/api';

  @override
  String get aesKey => 'my 32 length key................';

  @override
  _FirebaseConstants get _firebaseConstants => _ProductionFirebaseConstants();
}
