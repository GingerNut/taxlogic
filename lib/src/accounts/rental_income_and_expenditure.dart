

import 'income_and_expenditure.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../data/income_tax/income_tax_data.dart';
import '../entities/entity.dart';

class IncomeAndExpenditureProperty extends IncomeAndExpenditure{

  static const finance2018 = 0.25;
  static const finance2019 = 0.50;
  static const finance2020 = 0.75;
  static const finance2021 = 1;

  num _interestRestriction;
  num _taxCredit;

  IncomeAndExpenditureProperty(Period period, Entity entity) : super(period, entity);

  get interestRestriction{

    if(_interestRestriction != null) return _interestRestriction;

    _interestRestriction = 0;

    if(entity.type == Entity.INDIVIDUAL){

      expenditure.forEach((expense){

        if(expense.finance){
          _interestRestriction += expense.amount * financeAdjustment;
        }
      });
    }
    return _interestRestriction;
  }

  get financeAdjustment{

    if(entity.type != Entity.INDIVIDUAL) return 0;

    switch(period.end.year){
      case 2018: return finance2018;

      case 2019: return finance2019;

      case 2020: return finance2020;

      case 2021: return finance2021;

      default: return 1.0;

    }
  }

 get taxCredit{
    if(_taxCredit != null) return _taxCredit;

    if(interestRestriction != 0){

      IncomeTaxData taxData = IncomeTaxData.get(period.end.year, false);

      num basicRate = 0.2;

      if(taxData != null) {
        basicRate = taxData.BasicRate;
      }

      _taxCredit = interestRestriction * basicRate;
    } else _taxCredit = 0;

    return _taxCredit;
 }

  @override
  num adjustProfit(num profit){

   profit = profit + interestRestriction;

    return profit;
  }

}

