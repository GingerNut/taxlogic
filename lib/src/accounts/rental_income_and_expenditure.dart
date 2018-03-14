

import 'income_and_expenditure.dart';


class IncomeAndExpenditureProperty extends IncomeAndExpenditure{

  static const finance2018 = 0.25;
  static const finance2019 = 0.50;
  static const finance2020 = 0.75;
  static const finance2021 = 1;

  bool individualPropertyBusiness;

  IncomeAndExpenditureProperty(this.period);

  num taxCredit(int year){
    num taxCredit = 0;

    if(individualPropertyBusiness){
        num financeAdjustment;


        expenditure.forEach((expense){

          if(expense.finance) {


          switch(period.end.year){
            case 2018: financeAdjustment = finance2018;
            break;

            case 2019: financeAdjustment = finance2019;
            break;

            case 2020: financeAdjustment = finance2020;
            break;

            case 2021: financeAdjustment = finance2021;
            break;

            default: financeAdjustment = 1.0;
            break;
          }


            financeAdjustment += expense.amount * financeAdjustment;
          }
        });

        return financeAdjustment;

    }

    return taxCredit;
  }

}

