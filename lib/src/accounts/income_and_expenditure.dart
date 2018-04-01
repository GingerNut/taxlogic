import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../accounts/capital_allowances.dart';
import '../accounts/plant_and_machinery.dart';
import '../entities/entity.dart';
import 'accounting_period.dart';

class IncomeAndExpenditure extends AccountingPeriod{

  num _profit;

  List<Income> income = new List();
  List<Expenditure> expenditure = new List();
  List<PlantAndMachinery> plant = new List();

  num mainPool = 0;

  IncomeAndExpenditure(Period period, Entity entity): super(period, entity){

    if(period.end.month != 4 && period.end.day != 5)throw new StateError('only 5 April allowed in period');

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

    if(entry is Expenditure || entry is Interest) expenditure.add(entry);
    else if(entry is Income) income.add(entry);
  }
}

class Entry{
  String name;
  Date date;
  num amount = 0;

  Entry( this.date, this.name, this.amount,);
}

class Income extends Entry{

  Income(Date date, String name, num amount) : super(date, name, amount);

}


class Expenditure extends Entry{
  bool finance = false;

  Expenditure(Date date, String name, num amount) : super(date, name, amount);

}

class Interest extends Expenditure{

  Interest(Date date, String name, num amount) : super(date, name, amount){
    finance = true;

  }
}