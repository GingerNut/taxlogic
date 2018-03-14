import '../date.dart';
import '../period.dart';



class IncomeAndExpenditure{
  final Period period;
  num _profit;

  List<Income> income = new List();
  List<Expenditure> expenditure = new List();

  IncomeAndExpenditure(this.period);


  num get profit{
    if(_profit != null) return _profit;

    _profit = 0;

    income.forEach((receipt){
      _profit += receipt.amount;
    });

    expenditure.forEach((expense){
      _profit -= expense.amount;
    });

    return _profit;
  }
}

class Income{
  String name;
  Date date;
  num amount = 0;

}


class Expenditure{
  String name;
  Date date;
  bool finance = false;
  num amount = 0;

}