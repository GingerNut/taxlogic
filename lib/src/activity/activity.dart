import '../accounts/accounting_period.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../assets/value.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'employment.dart';
export 'trade.dart';
export 'savings.dart';
export 'share_holding.dart';
export 'property_business.dart';
export 'other.dart';

abstract class Activity extends Asset{
  String name;
  Date commencement;
  Date cessation;

  num lossBroughtForward = 0;
  num lossCarriedForward = 0;

  num taxableIncome = 0;
  num lossAvailable = 0;

  RateHistory annualIncome = new RateHistory.empty();

  List<Income> incomeHistory = new List();

  setIncome(num amount) => annualIncome.set(amount);

  List<AccountingPeriod> accounts = new List();

  Activity(Entity entity): super(entity){
    entity.activities.add(this);
  }

  transferToEntity(Date date, Entity transferee, Value value);

  Income income(TaxPosition taxPosition){
    Income income = new Income(this, taxPosition);

    income.income = annualIncome.overallAmount(taxPosition.period);

    return income;
  }

}