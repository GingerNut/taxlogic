
import 'tax_position/tax_position.dart';
import 'period.dart';
import 'entities/entity.dart';

class PeriodCollection{

  final Period period;
  final Entity entity;

  List<PeriodFraction> periods = new List();

  PeriodCollection(this.period, this.entity){

    entity.taxPeriods.forEach((test){

      int overlap = Period.overlap(test.period, period);
      
      if(overlap > 0) periods.add(new PeriodFraction(overlap, test));

    });
  }

}

class PeriodFraction{
  final int days;
  final TaxPosition taxPosition;

  PeriodFraction(this.days, this.taxPosition);

}