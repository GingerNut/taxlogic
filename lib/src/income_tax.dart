import 'dart:math';
import 'data/income_tax/income_tax_data.dart';
import 'tax_position.dart';
import 'person.dart';

class IncomeTaxPosition{

  final Person person;
  IncomeTaxData taxData;
  TaxPosition taxPosition;

  num personalAllowance;
  num totalIncome = 0;
  num taxableIncome = 0;
  num startRateUsed = 0;
  num basicRateUsed = 0;
  num intermediateRateUsed = 0;
  num higherRateUsed = 0;
  num additionalRateUsed = 0;

  num tax = 0.0;


  IncomeTaxPosition(this.person, this.taxPosition){
   taxData = IncomeTaxData.get(taxPosition.year, person.scotland);
  }

  void calculate(){
    totalIncome = taxPosition.earnings + taxPosition.trade;

    if(totalIncome > taxData.PersonalAllowanceTaperThreshold){

      personalAllowance = taxData.PersonalAllowanceDefault - (totalIncome - taxData.PersonalAllowanceTaperThreshold)/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(taxData.PersonalAllowanceDefault, totalIncome);

    taxableIncome = totalIncome - personalAllowance;

    if(person.scotland){

      if(totalIncome <=taxData.PersonalAllowanceDefault){
        personalAllowance = totalIncome;
      } else if(taxableIncome < taxData.StarterRateBand){

        startRateUsed = taxableIncome;
      } else if (taxableIncome< taxData.StarterRateBand + taxData.BasicRateBand){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxableIncome - startRateUsed;

      } else if(taxableIncome < taxData.StarterRateBand + taxData.BasicRateBand + taxData.IntermediateRateBand){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxableIncome - startRateUsed - basicRateUsed;
      } else if (taxableIncome < taxData.AdditionalRateLimit){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxData.IntermediateRateBand;
        higherRateUsed = taxableIncome - startRateUsed - basicRateUsed - intermediateRateUsed;
      } else {
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxData.IntermediateRateBand;
        higherRateUsed = taxData.AdditionalRateLimit - startRateUsed - basicRateUsed - intermediateRateUsed;
        additionalRateUsed = taxableIncome - taxData.AdditionalRateLimit;
      }


    } else if (totalIncome <= taxData.PersonalAllowanceDefault){

      personalAllowance = totalIncome;

    } else if(taxableIncome < taxData.BasicRateBand) {

      basicRateUsed = taxableIncome - startRateUsed;

    } else if(taxableIncome < taxData.AdditionalRateLimit){

      basicRateUsed = taxData.BasicRateBand;
      higherRateUsed = taxableIncome - basicRateUsed - intermediateRateUsed;;

    } else {

      basicRateUsed = taxData.BasicRateBand;
      higherRateUsed = taxData.AdditionalRateLimit - basicRateUsed - intermediateRateUsed - startRateUsed;
      additionalRateUsed = taxableIncome - taxData.AdditionalRateLimit;

    }

    tax = 0.0;
    tax += startRateUsed * taxData.StarterRate;
    tax += basicRateUsed * taxData.BasicRate;
    tax += intermediateRateUsed * taxData.IntermediateRate;
    tax += higherRateUsed * taxData.HigherRate;
    tax += additionalRateUsed * taxData.AdditionalRate;


  }




    List<List<String>> narrativeTaxCalc(List<List<String>> narrative){

    print("at narrative tax calc");

    //narrative.add(['','','','','','',]);

    narrative.add(['Total income','','','','',totalIncome.toString(),]);

    if(totalIncome > 0){
      narrative.add(['Personal Allowance','','','','',personalAllowance.toString(),]);
      narrative.add(['Net taxable','','','','',taxableIncome.toString(),]);
      narrative.add(['','','','','','',]);
    }

    if(taxableIncome > 0){
      narrative.add(['Tax payable','','','','','',]);

      if(startRateUsed > 0){
        narrative.add(['Starter Rate','','',startRateUsed.toString(),'at ${taxData.StarterRate*100}%',(startRateUsed*taxData.StarterRate).toString()]);
      }

      narrative.add(['Basic Rate','','',basicRateUsed.toString(),'at ${taxData.BasicRate*100}%',(basicRateUsed*taxData.BasicRate).toString()]);

      if(intermediateRateUsed > 0){
        narrative.add(['Intermediate Rate','','',intermediateRateUsed.toString(),'at ${taxData.IntermediateRate*100}%',(intermediateRateUsed*taxData.IntermediateRate).toString()]);
      }

      if(higherRateUsed > 0){
        narrative.add(['Higher Rate','','',higherRateUsed.toString(),'at ${taxData.HigherRate*100}%',(higherRateUsed*taxData.HigherRate).toString()]);
     }

      if(additionalRateUsed > 0){
        narrative.add(['Additional Rate','','',additionalRateUsed.toString(),'at ${taxData.AdditionalRate*100}%%',(additionalRateUsed*taxData.AdditionalRate).toString()]);
      }

      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
   }








}
