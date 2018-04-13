import 'income.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class DividendIncome extends Income{
  DividendIncome(this.shareholding, TaxPosition taxPosition) : super(shareholding, taxPosition);

  ShareHolding shareholding;

  num automaticIncome(Period period) => shareholding.company.getDividend(period, taxPosition.entity);



}


