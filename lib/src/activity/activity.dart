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
  Activity(Entity entity): super(entity){
    entity.activities.add(this);
  }

  static const EMPLOYMENT = 1;
  static const TRADE = 2;

  String name;
  Date commencement;
  Date cessation;

  num lossBroughtForward = 0;
  num lossCarriedForward = 0;

  num taxableIncome = 0;
  num lossAvailable = 0;

  RateHistory annualIncome = new RateHistory.empty();

  List<Income> incomeHistory = new List();

  setIncome(num amount) {
    if(commencement == null) annualIncome.set(amount);
    else {
      annualIncome.set(0);
      annualIncome.add(new RateChange(commencement, amount));
    }
  }

  Income getIncome(TaxPosition taxPosition){

    if(incomeHistory.length == 0) return new Income(this, taxPosition);

    Income income;

    incomeHistory.forEach((test){

      if(test.taxPosition == taxPosition) income = test;

    });

    if(income == null) income = new Income(this, taxPosition);

    return income;
  }

  List<AccountingPeriod> accounts = new List();



  transferToEntity(Date date, Entity transferee, Value value);


}