import 'package:taxlogic/src/utilities/date.dart';
import '../../entities/entity.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';

import 'package:taxlogic/src/utilities/period.dart';

class CapitalAllowances{
  static NumHistory individual_AIA = new NumHistory.fromList([
    new NumChange(new Date(6,4,08),50000),
    new NumChange(new Date(6,4,10),100000),
    new NumChange(new Date(6,4,12),25000),
    new NumChange(new Date(1,1,13),250000),
    new NumChange(new Date(6,4,14),500000),
    new NumChange(new Date(1,1,16),200000),
  ]);

  static NumHistory company_AIA = new NumHistory.fromList([
    new NumChange(new Date(1,4,08),50000),
    new NumChange(new Date(1,4,10),100000),
    new NumChange(new Date(1,4,12),25000),
    new NumChange(new Date(1,1,13),250000),
    new NumChange(new Date(1,4,14),500000),
    new NumChange(new Date(1,1,16),200000),
  ]);

  static num getAIA(Date date, Entity entity){
    if(entity.type == Entity.COMPANY){

      return company_AIA.valueAt(date);

    } else {

      return individual_AIA.valueAt(date);

    }

  }

  static List<NumPeriod> getAIAPeriods(Period period, Entity entity){
    if(entity.type == Entity.COMPANY){

      return company_AIA.getRatePeriods(period);

    } else {

      return individual_AIA.getRatePeriods(period);

    }


  }

  static getOverallAIA(Period period, Entity entity) {
    if(entity.type == Entity.COMPANY){

      return company_AIA.overallAmount(period);

    } else {

      return individual_AIA.overallAmount(period);

    }



  }


}