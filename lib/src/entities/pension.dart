import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';




class Pension extends Entity{









  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  TaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }
}