import 'package:decimal/decimal.dart';
import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/setting/subsidy_settings.dart';
import 'package:ufcat_ru_check/data/sheet/sheet.dart';
import 'package:ufcat_ru_check/data/sheet/sheet_repository.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/domain/use_case.dart';

class GetMealCostsInput {
  final Set<Student> students;
  final List<Sheet> sheets;
  final SubsidySettings settings;

  GetMealCostsInput(this.students, this.sheets, this.settings);
}

class GetMealCostsUseCase extends FutureUseCase<GetMealCostsInput, MealCosts> {
  final SheetDao _sheetRepository;

  GetMealCostsUseCase(this._sheetRepository);

  @override
  Future<MealCosts> perform(GetMealCostsInput input) async {
    final futureCosts = input.sheets.map((sheet) async {
      final snap = await _sheetRepository
          .queryEntries(sheet.id)
          .filterStudents(input.students)
          .get();
      final entries = snap.docs.map((e) => e.data());
      final total = input.settings.fullCost * Decimal.fromInt(entries.length);
      final sub = sheet.category.mealCost(input.settings) *
          Decimal.fromInt(entries.length);
      return MealCosts(total: total, subsidized: sub);
    });
    final mealCosts = await Future.wait(futureCosts);
    if (mealCosts.isEmpty) {
      return MealCosts(total: Decimal.zero, subsidized: Decimal.zero);
    }
    return mealCosts.reduce((acc, meal) => MealCosts(
          total: acc.total + meal.total,
          subsidized: acc.subsidized + meal.subsidized,
        ));
  }
}

extension on Category {
  Decimal mealCost(SubsidySettings settings) {
    switch (this) {
      case Category.free:
        return Decimal.zero;
      case Category.highSubsidized:
        return settings.highSubsidy;
      case Category.lowSubsidized:
        return settings.lowSubsidy;
      case Category.full:
        return settings.fullCost;
    }
  }
}

class MealCosts {
  final Decimal total;
  final Decimal subsidized;

  const MealCosts({required this.total, required this.subsidized});

  factory MealCosts.empty() =>
      MealCosts(total: Decimal.zero, subsidized: Decimal.zero);

  Decimal get paid => total - subsidized;
}
