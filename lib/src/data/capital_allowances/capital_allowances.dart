import '../../date.dart';
import '../../entities/entity.dart';
import '../../rate_history.dart';
import '../../period.dart';

class CapitalAllowances{
  static RateHistory individual_AIA = new RateHistory([
    new RateChange(new Date(6,4,08),50000),
    new RateChange(new Date(6,4,10),100000),
    new RateChange(new Date(6,4,12),25000),
    new RateChange(new Date(1,1,13),250000),
    new RateChange(new Date(6,4,14),500000),
    new RateChange(new Date(1,1,16),200000),
  ]);

  static RateHistory company_AIA = new RateHistory([
    new RateChange(new Date(1,4,08),50000),
    new RateChange(new Date(1,4,10),100000),
    new RateChange(new Date(1,4,12),25000),
    new RateChange(new Date(1,1,13),250000),
    new RateChange(new Date(1,4,14),500000),
    new RateChange(new Date(1,1,16),200000),
  ]);

  static num getAIA(Date date, Entity entity){
    if(entity.type == Class.company){

      return company_AIA.rateAt(date);

    } else {

      return individual_AIA.rateAt(date);

    }

  }

  static List<RatePeriod> getAIAPeriods(Period period, Entity entity){
    if(entity.type == Class.company){

      return company_AIA.getRatePeriods(period);

    } else {

      return individual_AIA.getRatePeriods(period);

    }


  }

  static getOverallAIA(Period period, Entity entity) {
    if(entity.type == Class.company){

      return company_AIA.overallRate(period);

    } else {

      return individual_AIA.overallRate(period);

    }



  }


}