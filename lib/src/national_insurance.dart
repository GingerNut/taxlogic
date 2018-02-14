import 'data/national_insurance/national_insurance_data.dart';

class NationalInsurancePosition{

  NationalInsuranceData nicData;

  int year;

  num totalIncome;
  num earnings;
  num trade;

  num earningsBetweenPTandUEL = 0;
  num earningsAboveUEL= 0;
  num earningsAboveSecondaryThreshold=0;
  num tradeAboveLowerLimit=0;
  num tradeAboveUpperLimit=0;

  num nicClass1p = 0.0;
  num nicClass1s = 0.0;
  num nicClass2 = 0.0;
  num nicClass3 = 0.0;
  num nicClass4 = 0.0;


  NationalInsurancePosition(this.year, this.earnings, this.trade){

    nicData = NationalInsuranceData.get(year);

      if(earnings > 0) Class1();

      if(trade > 0) Class4();

      Class2();

      // interraction

    }

    Class1(){

    if(earnings < nicData.C1PrimaryThreshold){

    } else if(earnings < nicData.C1UpperEarningsLimit){
        earningsBetweenPTandUEL = earnings - nicData.C1PrimaryThreshold;
      } else {
        earningsBetweenPTandUEL = nicData.C1UpperEarningsLimit - nicData.C1PrimaryThreshold;
        earningsAboveUEL = earnings - nicData.C1UpperEarningsLimit;
      }

      if(earnings > nicData.C1SecondaryThreshold) {
          earningsAboveSecondaryThreshold = earnings - nicData.C1SecondaryThreshold;

      }




      nicClass1p = 0;
      nicClass1p += earningsBetweenPTandUEL * nicData.C1RateToUEL;
      nicClass1p += earningsAboveUEL * nicData.C1RateAboveUEL;

      nicClass1s = 0;
      nicClass1s += earningsAboveSecondaryThreshold * nicData.C1RateSecondary;


    }

    Class2(){

    }

    Class4(){

    if(trade < nicData.C4UpperProfitLimit){

      if(trade > nicData.C4LowerProfitLimit) tradeAboveLowerLimit = trade - nicData.C4LowerProfitLimit;
    } else {

      tradeAboveLowerLimit = nicData.C4UpperProfitLimit - nicData.C4LowerProfitLimit;
      tradeAboveUpperLimit = trade - nicData.C4UpperProfitLimit;
    }

      nicClass4 = 0;
      nicClass4 += tradeAboveLowerLimit * nicData.C4RateToUpperLimit;
      nicClass4 += tradeAboveUpperLimit * nicData.C4RateAboveUpperLimit;
    }

    List<List<String>> narrativeNICCalc(){

    //narrative.add(['','','','','','',]);

    List<List<String>> narrative = new List<List<String>>();

    if(nicClass1p > 0) {
      narrative.add(['Primary Class 1 NIC', '', '', '', '', '',]);


      if (earnings > nicData.C1PrimaryThreshold) {
        narrative.add([
          'Earnings above primary threshold',
          '',
          '',
          '',
          '',
          earningsBetweenPTandUEL.toString(),
        ]);
      }

      if (earnings > nicData.C1UpperEarningsLimit) {
        narrative.add([
          'Earnings above Upper Earnings Limit',
          '',
          '',
          '',
          '',
          earningsAboveUEL.toString(),
        ]);
      }
      narrative.add([
        'Total primary class 1 NIC',
        '',
        '',
        '',
        '',
        nicClass1p.toString(),
      ]);

    }

    if(earningsAboveSecondaryThreshold > 0){

      narrative.add([
        'Total secondary class 1 NIC',
        '',
        '',
        '',
        '',
        nicClass1s.toString(),
      ]);
    }

    return narrative;
   }








}
