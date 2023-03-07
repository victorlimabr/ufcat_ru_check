import 'dart:math';

class AutoIdGenerator {
  static const int _autoIdLength = 20;

  static const String _autoIdAlphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  /// Automatically Generates a random new Id
  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = _autoIdAlphabet.length;

    for (int i = 0; i < _autoIdLength; ++i) {
      stringBuffer.write(_autoIdAlphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}
