import '../accounts/accounting_period.dart';
import '../entities/entity.dart';
import 'asset.dart';

class Activity extends Asset{
  DateTime commencement;
  DateTime cessation;

  num lossBroughtForward = 0;
  num lossCarriedForward = 0;

  num taxableIncome = 0;
  num lossAvailable = 0;

  List<AccountingPeriod> accounts = new List();

  Activity(Entity entity): super(entity);



}