import 'package:taxlogic/src/entities/person.dart';
import '../accounts/plant_and_machinery.dart';
import '../accounts/income_and_expenditure.dart';
import '../entities/entity.dart';
import '../accounts/trade_accounts.dart';
import 'activity.dart';

class Trade extends Activity{
  final Entity entity;
  DateTime commencement;
  DateTime cessation;

  Trade(this.entity);

  List<TradeAccounts> accounts = new List();




}