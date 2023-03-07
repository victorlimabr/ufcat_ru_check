import 'package:ufcat_ru_check/data/category/category.dart';
import 'package:ufcat_ru_check/data/setting/subsidy_settings.dart';

extension CategoryLabel on Category {
  String label(SubsidySettings settings) {
    switch (this) {
      case Category.free:
        return 'Bolsista integral';
      case Category.highSubsidized:
        return 'Subsidiado - R\$ ${settings.highSubsidy}';
      case Category.lowSubsidized:
        return 'Subsidiado - R\$ ${settings.lowSubsidy}';
      case Category.full:
        return 'Não subsidiado';
    }
  }
}
