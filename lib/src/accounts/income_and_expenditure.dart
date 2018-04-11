import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/period.dart';

import '../accounts/plant_and_machinery.dart';
import '../entities/entity.dart';
import 'accounting_period.dart';

class IncomeAndExpenditure extends AccountingPeriod{

  num _profit;

  List<IncomeAccount> income = new List();
  List<ExpenditureAccount> expenditure = new List();
  List<PlantAndMachinery> plant = new List();

  num mainPool = 0;

  IncomeAndExpenditure(Period period, Entity entity): super(period, entity){

   // if(period.end.month != 4 && period.end.day != 5)throw new StateError('only 5 April allowed in period');

  }


  num get profit{
    if(_profit != null) return _profit;

    _profit = 0;

    income.forEach((receipt){
      _profit += receipt.amount;
    });

    expenditure.forEach((expense){
      _profit -= expense.amount;
    });

    _profit = adjustProfit(_profit);

    return _profit;
  }

  num adjustProfit(num profit) => profit;


  add(Entry entry){

    if(entry is ExpenditureAccount || entry is Interest) expenditure.add(entry);
    else if(entry is IncomeAccount) income.add(entry);
  }
}

class Entry{
  String name;
  Date date;
  num amount = 0;

  Entry( this.date, this.name, this.amount,);
}

class IncomeAccount extends Entry{



  IncomeAccount(Date date, String name, num amount) : super(date, name, amount);

}


class ExpenditureAccount extends Entry{
  bool finance = false;

  ExpenditureAccount(Date date, String name, num amount) : super(date, name, amount);

}

class Interest extends ExpenditureAccount{

  Interest(Date date, String name, num amount) : super(date, name, amount){
    finance = true;

  }
}