import 'dart:math';
import '../data/income_tax/income_tax_data.dart';
import '../tax_position.dart';
import 'package:taxlogic/src/entities/person.dart';
import '../utilities.dart';

class IncomeTaxPosition{

  final Person person;
  IncomeTaxData taxData;
  TaxPosition taxPosition;

  num personalAllowance;
  num personalAllowanceUsed = 0;
  num taxableSavingsIncome = 0;
  num totalIncome = 0;
  num taxableIncome = 0;
  num taxableNonDividenIncome = 0;
  num savingsRateUsed = 0;
  num savingsAllowanceUsed = 0;
  num startRateUsed = 0;
  num basicRateUsed = 0;
  num intermediateRateUsed = 0;
  num higherRateUsed = 0;
  num additionalRateUsed = 0;

  num dividendNilRate = 0;
  num basicRateDividend = 0;
  num higherRateDividend = 0;
  num additionalRateDividend = 0;

  num savingsAllowance;
  num savingsNilRateBand;

  num tax = 0.0;


  IncomeTaxPosition(this.person, this.taxPosition){
   taxData = IncomeTaxData.get(taxPosition.year, person.scotland);
  }

  reset(){
    personalAllowanceUsed = 0;
    taxableSavingsIncome = 0;
    totalIncome = 0;
    taxableIncome = 0;
    taxableNonDividenIncome = 0;
    savingsRateUsed = 0;
    savingsAllowanceUsed = 0;
    startRateUsed = 0;
    basicRateUsed = 0;
    intermediateRateUsed = 0;
    higherRateUsed = 0;
    additionalRateUsed = 0;

    dividendNilRate = 0;
    basicRateDividend = 0;
    higherRateDividend = 0;
    additionalRateDividend = 0;

  }


  void calculate(){

    reset();

    totalIncome = taxPosition.earnings + taxPosition.trade + taxPosition.dividend + taxPosition.savings;

    num dividend = taxPosition.dividend;
    

    // savings
    savingsAllowance = totalIncome > taxData.PersonalAllowanceDefault + taxData.BasicRateBand ? taxData.SavingsAllowanceHigherRate : taxData.SavingsAllowanceBasicRate;
    savingsNilRateBand = taxData.SavingsStartingNilBand;
      if(totalIncome - taxPosition.savings > taxData.PersonalAllowanceDefault){
        savingsNilRateBand = max(0,taxData.SavingsStartingNilBand - max(0,totalIncome - taxPosition.savings-taxData.PersonalAllowanceDefault));
        if(savingsNilRateBand <0) savingsNilRateBand = 0;
      }


    taxableSavingsIncome = max(0, taxPosition.savings - savingsAllowance - savingsNilRateBand);
     totalIncome = totalIncome - taxPosition.savings + taxableSavingsIncome;



    num nonDividendIncome = totalIncome - dividend;

    // calculate personal allowance

    if(totalIncome > taxData.PersonalAllowanceTaperThreshold){

      personalAllowance = taxData.PersonalAllowanceDefault - (totalIncome - taxData.PersonalAllowanceTaperThreshold)/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(taxData.PersonalAllowanceDefault, totalIncome);

    taxableNonDividenIncome = max(0, nonDividendIncome - personalAllowance);

    if(person.scotland){

      if(nonDividendIncome <=taxData.PersonalAllowanceDefault){
        personalAllowanceUsed = nonDividendIncome;
      } else if(taxableNonDividenIncome < taxData.StarterRateBand){

        startRateUsed = taxableNonDividenIncome;
      } else if (taxableNonDividenIncome< taxData.StarterRateBand + taxData.BasicRateBand){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxableNonDividenIncome - startRateUsed;

      } else if(taxableNonDividenIncome < taxData.StarterRateBand + taxData.BasicRateBand + taxData.IntermediateRateBand){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed;
      } else if (taxableNonDividenIncome < taxData.AdditionalRateLimit){
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxData.IntermediateRateBand;
        higherRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed - intermediateRateUsed;
      } else {
        startRateUsed = taxData.StarterRateBand;
        basicRateUsed = taxData.BasicRateBand;
        intermediateRateUsed = taxData.IntermediateRateBand;
        higherRateUsed = taxData.AdditionalRateLimit - startRateUsed - basicRateUsed - intermediateRateUsed;
        additionalRateUsed = taxableNonDividenIncome - taxData.AdditionalRateLimit;
      }


    } else if (nonDividendIncome <= taxData.PersonalAllowanceDefault){

      personalAllowanceUsed = nonDividendIncome;

    } else if(taxableNonDividenIncome < taxData.BasicRateBand) {

      personalAllowanceUsed = personalAllowance;

      basicRateUsed = taxableNonDividenIncome - startRateUsed;

    } else if(taxableNonDividenIncome < taxData.AdditionalRateLimit){

      personalAllowanceUsed = personalAllowance;
      basicRateUsed = taxData.BasicRateBand;
      higherRateUsed = taxableNonDividenIncome - basicRateUsed - intermediateRateUsed;;

    } else {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = taxData.BasicRateBand;
      higherRateUsed = taxData.AdditionalRateLimit - basicRateUsed - intermediateRateUsed - startRateUsed;
      additionalRateUsed = taxableNonDividenIncome - taxData.AdditionalRateLimit;

    }


    // dividend tax

    num diviPersonalAllowance = personalAllowance - personalAllowanceUsed;

    num dividendRemaining = dividend - diviPersonalAllowance;

    num diviBasicRateLeft = taxData.BasicRateBand + taxData.StarterRateBand + taxData.IntermediateRateBand - basicRateUsed;
    num diviHigherRateLeft = taxData.AdditionalRateLimit - taxData.StarterRateBand - taxData.BasicRateBand - taxData.IntermediateRateBand - higherRateUsed;


    if(dividendRemaining < diviBasicRateLeft){
      basicRateDividend = dividendRemaining;
      dividendRemaining = 0;
    } else if (dividendRemaining > diviBasicRateLeft){
        basicRateDividend = diviBasicRateLeft;
        dividendRemaining -= diviBasicRateLeft;
    } else {
        basicRateDividend = dividendRemaining;
        dividendRemaining = 0;
    }

    if(dividendRemaining > diviHigherRateLeft){
      higherRateDividend = diviHigherRateLeft;
      dividendRemaining -= diviHigherRateLeft;
    } else {
      higherRateDividend = dividendRemaining;
      dividendRemaining = 0;
    }

    if(dividendRemaining > 0){
      additionalRateDividend = dividendRemaining;
    }

    // the dividend nil rate band


   num dividendNilRateBandRemaining = min(taxData.DividendNilBand, dividend);


    dividendNilRate = min(dividendNilRateBandRemaining, basicRateDividend);
    dividendNilRateBandRemaining -= dividendNilRate;
    basicRateDividend -= dividendNilRate;

    if(dividendNilRateBandRemaining > 0){
      num extraNilRate = min (dividendNilRateBandRemaining, higherRateDividend);
      dividendNilRate += extraNilRate;
      dividendNilRateBandRemaining -= extraNilRate;
      higherRateDividend -= extraNilRate;
    }

    if(dividendNilRateBandRemaining > 0){
      num extraNilRate = min(dividendNilRateBandRemaining, additionalRateDividend);
      dividendNilRate += extraNilRate;
      additionalRateDividend -= extraNilRate;
    }

    taxableIncome = totalIncome - personalAllowance;

    tax = 0.0;
    tax += startRateUsed * taxData.StarterRate;
    tax += basicRateUsed * taxData.BasicRate;
    tax += intermediateRateUsed * taxData.IntermediateRate;
    tax += higherRateUsed * taxData.HigherRate;
    tax += additionalRateUsed * taxData.AdditionalRate;

    tax += basicRateDividend * taxData.DividendBasicRate;
    tax += higherRateDividend * taxData.DividendHigherRate;
    tax += additionalRateDividend * taxData.DividendAdditionalRate;

    tax = Utilities.roundTax(tax);

  }

  num getBasicRateAvailable(){

    calculate();

    num basicRate = taxData.BasicRateBand + taxData.StarterRateBand + taxData.IntermediateRateBand;

    if(taxableIncome > basicRate){
      return 0;
    } else {
      return basicRate - taxableIncome;
    }


  }



    List<List<String>> narrativeTaxCalc(List<List<String>> narrative){

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

      if(dividendNilRate > 0){
        narrative.add(['Nil Rate Dividend','','',dividendNilRate.toString(),'at ${0*100}%%',(0).toString()]);
      }

      if(basicRateDividend > 0){
        narrative.add(['Basic Rate Dividend','','',basicRateDividend.toString(),'at ${taxData.DividendBasicRate*100}%%',(basicRateDividend*taxData.DividendBasicRate).toString()]);
      }

      if(higherRateDividend > 0){
        narrative.add(['Higher Rate Dividend','','',higherRateDividend.toString(),'at ${taxData.DividendHigherRate*100}%%',(higherRateDividend*taxData.DividendHigherRate).toString()]);
      }

      if(additionalRateDividend > 0){
        narrative.add(['Additional Rate Dividend','','',additionalRateDividend.toString(),'at ${taxData.DividendAdditionalRate*100}%%',(additionalRateDividend*taxData.DividendAdditionalRate).toString()]);
      }


      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
   }








}
