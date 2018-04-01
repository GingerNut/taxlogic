import 'package:taxlogic/src/utilities/period.dart';
import '../entities/entity.dart';


class AccountingPeriod{
  Entity entity;
  Period period;
  AccountingPeriod previousPeriod;

  AccountingPeriod(this.period, this.entity);


}