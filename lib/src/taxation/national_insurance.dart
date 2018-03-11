import '../data/national_insurance/national_insurance_data.dart';
import '../person.dart';
import '../tax_position.dart';
import '../utilities.dart';

class NationalInsurancePosition{

  Person person;
  TaxPosition taxPosition;
  NationalInsuranceData nicData;

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


  NationalInsurancePosition(this.person, this.taxPosition) {
    nicData = NationalInsuranceData.get(taxPosition.year);
  }

  void calculate(){

    earningsBetweenPTandUEL = 0;
    earningsAboveUEL= 0;
    earningsAboveSecondaryThreshold=0;
    tradeAboveLowerLimit=0;
    tradeAboveUpperLimit=0;

    nicClass1p = 0.0;
    nicClass1s = 0.0;
    nicClass2 = 0.0;
    nicClass3 = 0.0;
    nicClass4 = 0.0;

      if(taxPosition.earnings > 0) Class1();

      if(taxPosition.trade > 0) Class4();

      Class2();

      // interraction


    nicClass1p = Utilities.roundTax(nicClass1p);
    nicClass1s = Utilities.roundTax(nicClass1s);
    nicClass2 = Utilities.roundTax(nicClass2);
    nicClass3 = Utilities.roundTax(nicClass3);
    nicClass4 = Utilities.roundTax(nicClass4);

    }

    Class1(){

    if(taxPosition.earnings < nicData.C1PrimaryThreshold){

    } else if(taxPosition.earnings < nicData.C1UpperEarningsLimit){
        earningsBetweenPTandUEL = taxPosition.earnings - nicData.C1PrimaryThreshold;
      } else {
        earningsBetweenPTandUEL = nicData.C1UpperEarningsLimit - nicData.C1PrimaryThreshold;
        earningsAboveUEL = taxPosition.earnings - nicData.C1UpperEarningsLimit;
      }

      if(taxPosition.earnings > nicData.C1SecondaryThreshold) {
          earningsAboveSecondaryThreshold = taxPosition.earnings - nicData.C1SecondaryThreshold;

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

    if(taxPosition.trade < nicData.C4UpperProfitLimit){

      if(taxPosition.trade > nicData.C4LowerProfitLimit) tradeAboveLowerLimit = taxPosition.trade - nicData.C4LowerProfitLimit;
    } else {

      tradeAboveLowerLimit = nicData.C4UpperProfitLimit - nicData.C4LowerProfitLimit;
      tradeAboveUpperLimit = taxPosition.trade - nicData.C4UpperProfitLimit;
    }

      nicClass4 = 0;
      nicClass4 += tradeAboveLowerLimit * nicData.C4RateToUpperLimit;
      nicClass4 += tradeAboveUpperLimit * nicData.C4RateAboveUpperLimit;
    }

    List<List<String>> narrativeNICCalc(List<List<String>> narrative){

    //narrative.add(['','','','','','',]);

    if(nicClass1p > 0) {
      narrative.add(['Primary Class 1 NIC', '', '', '', '', '',]);


      if (taxPosition.earnings > nicData.C1PrimaryThreshold) {
        narrative.add([
          'Earnings above primary threshold',
          '',
          '',
          '',
          '',
          earningsBetweenPTandUEL.toString(),
        ]);
      }

      if (taxPosition.earnings > nicData.C1UpperEarningsLimit) {
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
