import 'entity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';


class Trust extends Entity{

  Trust(){
    type = Entity.TRUST;


  }



  @override
  num taxPayble(int taxYearEnd) {
    // TODO: implement taxPayble
  }

  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  TaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }
}