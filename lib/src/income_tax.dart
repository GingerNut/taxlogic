import 'dart:math';

class IncomeTaxPosition{

  static const num PersonalAllowanceDefault = 11500;
  static const num BasicRateBand = 33500.0;
  static const num PersonalAllowanceTaper = 100000;
  static const num AdditionalRateLimit = 150000;

  static const num BasicRate = 0.20;
  static const num HigherRate = 0.4;
  static const num AdditionalRate = 0.45;


  int year;
  bool Scotland = false;

  num personalAllowance;
  num totalIncome;
  num taxableIncome;
  num basicRateUsed = 0;
  num higherRateUsed = 0;
  num additionalRateUsed = 0;
  num earnings;
  num dividends;
  num interest;
  num trade;
  num pension;
  num tax = 0.0;

  IncomeTaxPosition(this.year, this.totalIncome){

    if(totalIncome > PersonalAllowanceTaper){

      personalAllowance = PersonalAllowanceDefault - (totalIncome - PersonalAllowanceTaper)/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(PersonalAllowanceDefault, totalIncome);

    taxableIncome = totalIncome - personalAllowance;

    if(totalIncome <= PersonalAllowanceDefault){

      personalAllowance = totalIncome;

    } else if(taxableIncome < BasicRateBand){

      basicRateUsed = taxableIncome;

    } else if(taxableIncome < AdditionalRateLimit){

      basicRateUsed = BasicRateBand;
      higherRateUsed = taxableIncome - basicRateUsed;

    } else {

      basicRateUsed = BasicRateBand;
      higherRateUsed = AdditionalRateLimit - BasicRateBand;
      additionalRateUsed = taxableIncome - AdditionalRateLimit;

    }

    tax = 0.0;
    tax += basicRateUsed * BasicRate;
    tax += higherRateUsed * HigherRate;
    tax += additionalRateUsed * AdditionalRate;

    }

    List<List<String>> narrativeTaxCalc(){

    //narrative.add(['','','','','','',]);

    List<List<String>> narrative = new List<List<String>>();

    narrative.add(['Total income','','','','',totalIncome.toString(),]);

    if(totalIncome > 0){
      narrative.add(['Personal Allowance','','','','',personalAllowance.toString(),]);
      narrative.add(['Net taxable','','','','',taxableIncome.toString(),]);
      narrative.add(['','','','','','',]);
    }

    if(taxableIncome > 0){
      narrative.add(['Tax payable','','','','','',]);
      narrative.add(['Basic Rate','','',basicRateUsed.toString(),'at ${BasicRate*100}%',(basicRateUsed*BasicRate).toString()]);

      if(higherRateUsed > 0){
        narrative.add(['Higher Rate','','',higherRateUsed.toString(),'at ${HigherRate*100}%',(higherRateUsed*HigherRate).toString()]);
     }

      if(additionalRateUsed > 0){
        narrative.add(['Additional Rate','','',additionalRateUsed.toString(),'at ${AdditionalRate*100}%%',(additionalRateUsed*AdditionalRate).toString()]);
      }

      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
   }








}
