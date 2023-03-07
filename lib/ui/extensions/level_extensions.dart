import 'package:ufcat_ru_check/data/level/level.dart';

extension LevelLabel on Level {
  String get label {
    switch (this) {
      case Level.undergraduate:
        return 'Graduação';
      case Level.latoSensu:
        return 'Pós-graduação';
      case Level.strictoSensu:
        return 'Mestrado';
    }
  }
}
