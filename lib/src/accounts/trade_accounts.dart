import 'income_and_expenditure.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../entities/entity.dart';

class TradeAccounts extends IncomeAndExpenditure{
  Period period;

  TradeAccounts(Period period, Entity entity) : super(period, entity);




}