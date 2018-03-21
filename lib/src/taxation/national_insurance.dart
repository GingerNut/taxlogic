import '../data/national_insurance/national_insurance_data.dart';
import 'package:taxlogic/src/entities/person.dart';
import 'package:taxlogic/src/tax_position/personal_tax_position.dart';
import '../utilities.dart';
import '../data/tax_data.dart';
import 'income.dart';

class NationalInsurancePosition extends Income{

  Person person;


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


  NationalInsurancePosition(PersonalTaxPosition taxPosition) : super(taxPosition);

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

      if((taxPosition as PersonalTaxPosition).earnings > 0) Class1();

      if((taxPosition as PersonalTaxPosition).trade > 0) Class4();

      Class2();

      // interraction


    nicClass1p = Utilities.roundTax(nicClass1p);
    nicClass1s = Utilities.roundTax(nicClass1s);
    nicClass2 = Utilities.roundTax(nicClass2);
    nicClass3 = Utilities.roundTax(nicClass3);
    nicClass4 = Utilities.roundTax(nicClass4);

    }

    Class1(){

    if((taxPosition as PersonalTaxPosition).earnings < TaxData.C1PrimaryThreshold((taxPosition as PersonalTaxPosition).period.end.year)){

    } else if((taxPosition as PersonalTaxPosition).earnings < TaxData.C1UpperEarningsLimit((taxPosition as PersonalTaxPosition).period.end.year)){
        earningsBetweenPTandUEL = (taxPosition as PersonalTaxPosition).earnings - TaxData.C1PrimaryThreshold((taxPosition as PersonalTaxPosition).period.end.year);
      } else {
        earningsBetweenPTandUEL = TaxData.C1UpperEarningsLimit((taxPosition as PersonalTaxPosition).period.end.year) - TaxData.C1PrimaryThreshold((taxPosition as PersonalTaxPosition).period.end.year);
        earningsAboveUEL = (taxPosition as PersonalTaxPosition).earnings - TaxData.C1UpperEarningsLimit((taxPosition as PersonalTaxPosition).period.end.year);
      }

      if((taxPosition as PersonalTaxPosition).earnings > TaxData.C1SecondaryThreshold((taxPosition as PersonalTaxPosition).period.end.year)) {
          earningsAboveSecondaryThreshold = (taxPosition as PersonalTaxPosition).earnings - TaxData.C1SecondaryThreshold((taxPosition as PersonalTaxPosition).period.end.year);

      }




      nicClass1p = 0;
      nicClass1p += earningsBetweenPTandUEL * TaxData.C1RateToUEL((taxPosition as PersonalTaxPosition).period.end.year);
      nicClass1p += earningsAboveUEL * TaxData.C1RateAboveUEL((taxPosition as PersonalTaxPosition).period.end.year);

      nicClass1s = 0;
      nicClass1s += earningsAboveSecondaryThreshold * TaxData.C1RateSecondary((taxPosition as PersonalTaxPosition).period.end.year);


    }

    Class2(){

    }

    Class4(){

    if((taxPosition as PersonalTaxPosition).trade < TaxData.C4UpperProfitLimit((taxPosition as PersonalTaxPosition).period.end.year)){

      if((taxPosition as PersonalTaxPosition).trade > TaxData.C4LowerProfitLimit((taxPosition as PersonalTaxPosition).period.end.year)) tradeAboveLowerLimit = (taxPosition as PersonalTaxPosition).trade - TaxData.C4LowerProfitLimit((taxPosition as PersonalTaxPosition).period.end.year);
    } else {

      tradeAboveLowerLimit = TaxData.C4UpperProfitLimit((taxPosition as PersonalTaxPosition).period.end.year) - TaxData.C4LowerProfitLimit((taxPosition as PersonalTaxPosition).period.end.year);
      tradeAboveUpperLimit = (taxPosition as PersonalTaxPosition).trade - TaxData.C4UpperProfitLimit((taxPosition as PersonalTaxPosition).period.end.year);
    }

      nicClass4 = 0;
      nicClass4 += tradeAboveLowerLimit * TaxData.C4RateToUpperLimit((taxPosition as PersonalTaxPosition).period.end.year);
      nicClass4 += tradeAboveUpperLimit * TaxData.C4RateAboveUpperLimit((taxPosition as PersonalTaxPosition).period.end.year);
    }

    List<List<String>> narrativeNICCalc(List<List<String>> narrative){

    //narrative.add(['','','','','','',]);

    if(nicClass1p > 0) {
      narrative.add(['Primary Class 1 NIC', '', '', '', '', '',]);


      if ((taxPosition as PersonalTaxPosition).earnings > TaxData.C1PrimaryThreshold((taxPosition as PersonalTaxPosition).period.end.year)) {
        narrative.add([
          'Earnings above primary threshold',
          '',
          '',
          '',
          '',
          earningsBetweenPTandUEL.toString(),
        ]);
      }

      if ((taxPosition as PersonalTaxPosition).earnings > TaxData.C1UpperEarningsLimit((taxPosition as PersonalTaxPosition).period.end.year)) {
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
