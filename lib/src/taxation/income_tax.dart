import 'dart:math';
import 'package:taxlogic/src/tax_position/personal_tax_position.dart';
import 'package:taxlogic/src/entities/person.dart';
import '../utilities.dart';
import '../data/tax_data.dart';
import 'income.dart';

class IncomeTaxPosition extends Income{

  PersonalTaxPosition taxPosition;

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


  IncomeTaxPosition(Person person, this.taxPosition) :super(person);

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
    
    var person = entity as Person;
   
    reset();

    totalIncome = taxPosition.earnings + taxPosition.trade + taxPosition.dividend + taxPosition.savings;

    num dividend = taxPosition.dividend;
    

  

    // savings
    savingsAllowance = totalIncome > TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland) + TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland) ? TaxData.savingsAllowanceHigherRate(taxPosition.period.end.year, person.scotland) : TaxData.savingsAllowanceBasicRate(taxPosition.period.end.year, person.scotland);
    savingsNilRateBand = TaxData.savingsStartingNilBand(taxPosition.period.end.year, person.scotland);
      if(totalIncome - taxPosition.savings > TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland)){
        savingsNilRateBand = max(0,TaxData.savingsStartingNilBand(taxPosition.period.end.year, person.scotland) - max(0,totalIncome - taxPosition.savings-TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland)));
        if(savingsNilRateBand <0) savingsNilRateBand = 0;
      }


    taxableSavingsIncome = max(0, taxPosition.savings - savingsAllowance - savingsNilRateBand);
     totalIncome = totalIncome - taxPosition.savings + taxableSavingsIncome;



    num nonDividendIncome = totalIncome - dividend;

    // calculate personal allowance

    if(totalIncome > TaxData.PersonalAllowanceTaperThreshold(taxPosition.period.end.year, person.scotland)){

      personalAllowance = TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland) - (totalIncome - TaxData.PersonalAllowanceTaperThreshold(taxPosition.period.end.year, person.scotland))/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland), totalIncome);

    taxableNonDividenIncome = max(0, nonDividendIncome - personalAllowance);

    if(person.scotland){

      if(nonDividendIncome <=TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland)){
        personalAllowanceUsed = nonDividendIncome;
      } else if(taxableNonDividenIncome < TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland)){

        startRateUsed = taxableNonDividenIncome;
      } else if (taxableNonDividenIncome< TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland) + TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland)){
        startRateUsed = TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland);
        basicRateUsed = taxableNonDividenIncome - startRateUsed;

      } else if(taxableNonDividenIncome < TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland) + TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland) + TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland)){
        startRateUsed = TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland);
        basicRateUsed = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland);
        intermediateRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed;
      } else if (taxableNonDividenIncome < TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland)){
        startRateUsed = TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland);
        basicRateUsed = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland);
        higherRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed - intermediateRateUsed;
      } else {
        startRateUsed = TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland);
        basicRateUsed = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland);
        higherRateUsed = TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland) - startRateUsed - basicRateUsed - intermediateRateUsed;
        additionalRateUsed = taxableNonDividenIncome - TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland);
      }


    } else if (nonDividendIncome <= TaxData.PersonalAllowanceDefault(taxPosition.period.end.year, person.scotland)){

      personalAllowanceUsed = nonDividendIncome;

    } else if(taxableNonDividenIncome < TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland)) {

      personalAllowanceUsed = personalAllowance;

      basicRateUsed = taxableNonDividenIncome - startRateUsed;

    } else if(taxableNonDividenIncome < TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland)){

      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland);
      higherRateUsed = taxableNonDividenIncome - basicRateUsed - intermediateRateUsed;;

    } else {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland);
      higherRateUsed = TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland) - basicRateUsed - intermediateRateUsed - startRateUsed;
      additionalRateUsed = taxableNonDividenIncome - TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland);

    }


    // dividend tax

    num diviPersonalAllowance = personalAllowance - personalAllowanceUsed;

    num dividendRemaining = dividend - diviPersonalAllowance;

    num diviBasicRateLeft = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland) + TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland) + TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland) - basicRateUsed;
    num diviHigherRateLeft = TaxData.AdditionalRateLimit(taxPosition.period.end.year, person.scotland) - TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland) - TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland) - TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland) - higherRateUsed;


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


   num dividendNilRateBandRemaining = min(TaxData.DividendNilBand(taxPosition.period.end.year, person.scotland), dividend);


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
    tax += startRateUsed * TaxData.StarterRate(taxPosition.period.end.year, person.scotland);
    tax += basicRateUsed * TaxData.BasicRate(taxPosition.period.end.year, person.scotland);
    tax += intermediateRateUsed * TaxData.IntermediateRate(taxPosition.period.end.year, person.scotland);
    tax += higherRateUsed * TaxData.HigherRate(taxPosition.period.end.year, person.scotland);
    tax += additionalRateUsed * TaxData.AdditionalRate(taxPosition.period.end.year, person.scotland);

    tax += basicRateDividend * TaxData.DividendBasicRate(taxPosition.period.end.year, person.scotland);
    tax += higherRateDividend * TaxData.DividendHigherRate(taxPosition.period.end.year, person.scotland);
    tax += additionalRateDividend * TaxData.DividendAdditionalRate(taxPosition.period.end.year, person.scotland);

    tax = Utilities.roundTax(tax);

  }

  num getBasicRateAvailable(){

    var person = entity as Person;

    calculate();

    num basicRate = TaxData.BasicRateBand(taxPosition.period.end.year, person.scotland) + TaxData.StarterRateBand(taxPosition.period.end.year, person.scotland) + TaxData.IntermediateRateBand(taxPosition.period.end.year, person.scotland);

    if(taxableIncome > basicRate){
      return 0;
    } else {
      return basicRate - taxableIncome;
    }


  }



    List<List<String>> narrativeTaxCalc(List<List<String>> narrative){

      var person = entity as Person;

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
        narrative.add(['Starter Rate','','',startRateUsed.toString(),'at ${TaxData.StarterRate(taxPosition.period.end.year, person.scotland)*100}%',(startRateUsed*TaxData.StarterRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }

      narrative.add(['Basic Rate','','',basicRateUsed.toString(),'at ${TaxData.BasicRate(taxPosition.period.end.year, person.scotland)*100}%',(basicRateUsed*TaxData.BasicRate(taxPosition.period.end.year, person.scotland)).toString()]);

      if(intermediateRateUsed > 0){
        narrative.add(['Intermediate Rate','','',intermediateRateUsed.toString(),'at ${TaxData.IntermediateRate(taxPosition.period.end.year, person.scotland)*100}%',(intermediateRateUsed*TaxData.IntermediateRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }

      if(higherRateUsed > 0){
        narrative.add(['Higher Rate','','',higherRateUsed.toString(),'at ${TaxData.HigherRate(taxPosition.period.end.year, person.scotland)*100}%',(higherRateUsed*TaxData.HigherRate(taxPosition.period.end.year, person.scotland)).toString()]);
     }

      if(additionalRateUsed > 0){
        narrative.add(['Additional Rate','','',additionalRateUsed.toString(),'at ${TaxData.AdditionalRate(taxPosition.period.end.year, person.scotland)*100}%%',(additionalRateUsed*TaxData.AdditionalRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }

      if(dividendNilRate > 0){
        narrative.add(['Nil Rate Dividend','','',dividendNilRate.toString(),'at ${0*100}%%',(0).toString()]);
      }

      if(basicRateDividend > 0){
        narrative.add(['Basic Rate Dividend','','',basicRateDividend.toString(),'at ${TaxData.DividendBasicRate(taxPosition.period.end.year, person.scotland)*100}%%',(basicRateDividend*TaxData.DividendBasicRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }

      if(higherRateDividend > 0){
        narrative.add(['Higher Rate Dividend','','',higherRateDividend.toString(),'at ${TaxData.DividendHigherRate(taxPosition.period.end.year, person.scotland)*100}%%',(higherRateDividend*TaxData.DividendHigherRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }

      if(additionalRateDividend > 0){
        narrative.add(['Additional Rate Dividend','','',additionalRateDividend.toString(),'at ${TaxData.DividendAdditionalRate(taxPosition.period.end.year, person.scotland)*100}%%',(additionalRateDividend*TaxData.DividendAdditionalRate(taxPosition.period.end.year, person.scotland)).toString()]);
      }


      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
   }








}
