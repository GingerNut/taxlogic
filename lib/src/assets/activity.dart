import '../accounts/accounting_period.dart';
import '../entities/entity.dart';
import 'asset.dart';
import '../date.dart';
import '../assets/value.dart';

abstract class Activity extends Asset{
  String name;
  Date commencement;
  Date cessation;

  num lossBroughtForward = 0;
  num lossCarriedForward = 0;

  num taxableIncome = 0;
  num lossAvailable = 0;

  List<AccountingPeriod> accounts = new List();

  Activity(Entity entity): super(entity);

  transferToEntity(Date date, Entity transferee, Value value);



}