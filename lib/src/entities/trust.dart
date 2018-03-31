import 'entity.dart';
import 'package:taxlogic/src/date.dart';
import 'package:taxlogic/src/period.dart';
import 'package:taxlogic/src/period_collection.dart';
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