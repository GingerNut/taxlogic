import 'entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';

class Unknown extends Entity{



  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  TaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }
}