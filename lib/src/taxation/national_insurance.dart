import '../data/national_insurance/national_insurance_data.dart';
import 'package:taxlogic/src/entities/person.dart';
import 'package:taxlogic/src/tax_position/personal_tax_position.dart';
import '../utilities.dart';
import '../data/tax_data.dart';

class NationalInsurancePosition{

  Person person;
  PersonalTaxPosition taxPosition;


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


  NationalInsurancePosition(this.person, this.taxPosition);

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

    if(taxPosition.earnings < TaxData.C1PrimaryThreshold(taxPosition.period.end.year)){

    } else if(taxPosition.earnings < TaxData.C1UpperEarningsLimit(taxPosition.period.end.year)){
        earningsBetweenPTandUEL = taxPosition.earnings - TaxData.C1PrimaryThreshold(taxPosition.period.end.year);
      } else {
        earningsBetweenPTandUEL = TaxData.C1UpperEarningsLimit(taxPosition.period.end.year) - TaxData.C1PrimaryThreshold(taxPosition.period.end.year);
        earningsAboveUEL = taxPosition.earnings - TaxData.C1UpperEarningsLimit(taxPosition.period.end.year);
      }

      if(taxPosition.earnings > TaxData.C1SecondaryThreshold(taxPosition.period.end.year)) {
          earningsAboveSecondaryThreshold = taxPosition.earnings - TaxData.C1SecondaryThreshold(taxPosition.period.end.year);

      }




      nicClass1p = 0;
      nicClass1p += earningsBetweenPTandUEL * TaxData.C1RateToUEL(taxPosition.period.end.year);
      nicClass1p += earningsAboveUEL * TaxData.C1RateAboveUEL(taxPosition.period.end.year);

      nicClass1s = 0;
      nicClass1s += earningsAboveSecondaryThreshold * TaxData.C1RateSecondary(taxPosition.period.end.year);


    }

    Class2(){

    }

    Class4(){

    if(taxPosition.trade < TaxData.C4UpperProfitLimit(taxPosition.period.end.year)){

      if(taxPosition.trade > TaxData.C4LowerProfitLimit(taxPosition.period.end.year)) tradeAboveLowerLimit = taxPosition.trade - TaxData.C4LowerProfitLimit(taxPosition.period.end.year);
    } else {

      tradeAboveLowerLimit = TaxData.C4UpperProfitLimit(taxPosition.period.end.year) - TaxData.C4LowerProfitLimit(taxPosition.period.end.year);
      tradeAboveUpperLimit = taxPosition.trade - TaxData.C4UpperProfitLimit(taxPosition.period.end.year);
    }

      nicClass4 = 0;
      nicClass4 += tradeAboveLowerLimit * TaxData.C4RateToUpperLimit(taxPosition.period.end.year);
      nicClass4 += tradeAboveUpperLimit * TaxData.C4RateAboveUpperLimit(taxPosition.period.end.year);
    }

    List<List<String>> narrativeNICCalc(List<List<String>> narrative){

    //narrative.add(['','','','','','',]);

    if(nicClass1p > 0) {
      narrative.add(['Primary Class 1 NIC', '', '', '', '', '',]);


      if (taxPosition.earnings > TaxData.C1PrimaryThreshold(taxPosition.period.end.year)) {
        narrative.add([
          'Earnings above primary threshold',
          '',
          '',
          '',
          '',
          earningsBetweenPTandUEL.toString(),
        ]);
      }

      if (taxPosition.earnings > TaxData.C1UpperEarningsLimit(taxPosition.period.end.year)) {
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
