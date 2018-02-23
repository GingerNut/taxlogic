import 'dart:math';
import 'data/income_tax/income_tax_data.dart';
import 'tax_position.dart';
import 'person.dart';

class IncomeTaxPosition{

  final Person person;
  IncomeTaxData taxData;
  TaxPosition taxPosition;

  num personalAllowance;
  num personalAllowanceUsed = 0;
  num totalIncome = 0;
  num taxableIncome = 0;
  num startRateUsed = 0;
  num basicRateUsed = 0;
  num intermediateRateUsed = 0;
  num higherRateUsed = 0;
  num additionalRateUsed = 0;

  num dividendNilRate = 0;
  num basicRateDividend = 0;
  num higherRateDividend = 0;
  num additionalRateDividend = 0;

  num tax = 0.0;


  IncomeTaxPosition(this.person, this.taxPosition){
   taxData = IncomeTaxData.get(taxPosition.year, person.scotland);
  }

  void calculate(){


    totalIncome = taxPosition.earnings + taxPosition.trade + taxPosition.dividend;

    num dividend = taxPosition.dividend;
    num nonDividendIncome = totalIncome - dividend;

    if(totalIncome > taxData.PersonalAllowanceTaperThreshold){

      personalAllowance = taxData.PersonalAllowanceDefault - (totalIncome - taxData.PersonalAllowanceTaperThreshold)/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(taxData.PersonalAllowanceDefault, nonDividendIncome);

    taxableIncome = nonDividendIncome - personalAllowance;

    if(person.scotland){

      if(nonDividendIncome <=taxData.PersonalAllowanceDefault){
        personalAllowanceUsed = nonDividendIncome;
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


    } else if (nonDividendIncome <= taxData.PersonalAllowanceDefault){

      personalAllowanceUsed = nonDividendIncome;

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
    
    
    
    // dividend tax

   num dividendRemaining = dividend;


    num diviPersonalAllowance = taxData.PersonalAllowanceDefault;

    if(totalIncome > taxData.PersonalAllowanceTaperThreshold){
      diviPersonalAllowance = max(0, taxData.PersonalAllowanceDefault - (totalIncome - taxData.PersonalAllowanceTaperThreshold)/2);
    }


    num diviBasicRateLeft = taxData.BasicRateBand + taxData.StarterRateBand + taxData.IntermediateRateBand - basicRateUsed;
    num diviHigherRateLeft = taxData.AdditionalRateLimit - taxData.StarterRateBand - taxData.BasicRateBand - taxData.IntermediateRateBand - higherRateUsed;


    if(nonDividendIncome > diviPersonalAllowance){
      diviPersonalAllowance = 0;

    } else {
      dividendRemaining -= (diviPersonalAllowance - nonDividendIncome);
    }

    if(dividendRemaining > diviBasicRateLeft){
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


    print("Dividind $dividend");

    print("Basic rate used $basicRateUsed");
    print("divid nil rate $dividendNilRate");
    print("Divi basic rate $basicRateDividend");
    print("hgher rate divi $higherRateDividend");
    print("Add rate divid $additionalRateDividend");

    

    tax = 0.0;
    tax += startRateUsed * taxData.StarterRate;
    tax += basicRateUsed * taxData.BasicRate;
    tax += intermediateRateUsed * taxData.IntermediateRate;
    tax += higherRateUsed * taxData.HigherRate;
    tax += additionalRateUsed * taxData.AdditionalRate;

    tax += basicRateDividend * taxData.DividendBasicRate;
    tax += higherRateDividend * taxData.DividendHigherRate;
    tax += additionalRateDividend * taxData.DividendAdditionalRate;


  }




    List<List<String>> narrativeTaxCalc(List<List<String>> narrative){

    //narrative.add(['','','','','','',]);

    narrative.add(['Total income','','','','',totalIncome.toString(),]);

    if(totalIncome > 0){
      narrative.add(['Personal Allowance','','','','',personalAllowanceUsed.toString(),]);
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
