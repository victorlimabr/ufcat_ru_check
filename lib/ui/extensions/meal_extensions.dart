import 'package:ufcat_ru_check/data/meal/meal.dart';

extension MealLabel on Meal {
  String get label {
    switch (this) {
      case Meal.lunch:
        return 'Almoço';
      case Meal.dinner:
        return 'Jantar';
    }
  }
}
