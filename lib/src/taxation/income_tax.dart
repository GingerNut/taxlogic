import 'dart:math';
import 'package:taxlogic/src/tax_position/personal_tax_position.dart';
import 'package:taxlogic/src/entities/person.dart';
import '../utilities.dart';
import '../data/tax_data.dart';
import 'taxation.dart';
import '../tax_position/tax_position.dart';

class IncomeTaxPosition extends Taxation{

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


  IncomeTaxPosition(TaxPosition taxPosition) : super(taxPosition);

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

    tax = 0.0;

    taxPosition.refreshIncome();
   
    reset();

    totalIncome = (taxPosition as PersonalTaxPosition).earnings + (taxPosition as PersonalTaxPosition).trade + (taxPosition as PersonalTaxPosition).dividend + (taxPosition as PersonalTaxPosition).savings + taxPosition.propertyIncome;

    num dividend = (taxPosition as PersonalTaxPosition).dividend;
    

  

    // savings
    savingsAllowance = totalIncome > TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) ? TaxData.savingsAllowanceHigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) : TaxData.savingsAllowanceBasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    savingsNilRateBand = TaxData.savingsStartingNilBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
      if(totalIncome - (taxPosition as PersonalTaxPosition).savings > TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){
        savingsNilRateBand = max(0,TaxData.savingsStartingNilBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - max(0,totalIncome - (taxPosition as PersonalTaxPosition).savings-TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)));
        if(savingsNilRateBand <0) savingsNilRateBand = 0;
      }


    taxableSavingsIncome = max(0, (taxPosition as PersonalTaxPosition).savings - savingsAllowance - savingsNilRateBand);
     totalIncome = totalIncome - (taxPosition as PersonalTaxPosition).savings + taxableSavingsIncome;



    num nonDividendIncome = totalIncome - dividend;

    // calculate personal allowance

    if(totalIncome > TaxData.PersonalAllowanceTaperThreshold((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){

      personalAllowance = TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - (totalIncome - TaxData.PersonalAllowanceTaperThreshold((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland))/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = min(TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland), totalIncome);

    taxableNonDividenIncome = max(0, nonDividendIncome - personalAllowance);

    if((taxPosition.entity as Person).scotland){

      if(nonDividendIncome <=TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){
        personalAllowanceUsed = nonDividendIncome;
      } else if(taxableNonDividenIncome < TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){

        startRateUsed = taxableNonDividenIncome;
      } else if (taxableNonDividenIncome< TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){
        startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        basicRateUsed = taxableNonDividenIncome - startRateUsed;

      } else if(taxableNonDividenIncome < TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){
        startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        intermediateRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed;
      } else if (taxableNonDividenIncome < TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){
        startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        higherRateUsed = taxableNonDividenIncome - startRateUsed - basicRateUsed - intermediateRateUsed;
      } else {
        startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
        higherRateUsed = TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - startRateUsed - basicRateUsed - intermediateRateUsed;
        additionalRateUsed = taxableNonDividenIncome - TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
      }


    } else if (nonDividendIncome <= TaxData.PersonalAllowanceDefault((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){

      personalAllowanceUsed = nonDividendIncome;

    } else if(taxableNonDividenIncome < TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)) {

      personalAllowanceUsed = personalAllowance;

      basicRateUsed = taxableNonDividenIncome - startRateUsed;

    } else if(taxableNonDividenIncome < TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)){

      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
      higherRateUsed = taxableNonDividenIncome - basicRateUsed - intermediateRateUsed;;

    } else {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
      higherRateUsed = TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - basicRateUsed - intermediateRateUsed - startRateUsed;
      additionalRateUsed = taxableNonDividenIncome - TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);

    }


    // dividend tax

    num diviPersonalAllowance = personalAllowance - personalAllowanceUsed;

    num dividendRemaining = dividend - diviPersonalAllowance;

    num diviBasicRateLeft = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - basicRateUsed;
    num diviHigherRateLeft = TaxData.AdditionalRateLimit((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) - higherRateUsed;


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


   num dividendNilRateBandRemaining = min(TaxData.DividendNilBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland), dividend);


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
    tax += startRateUsed * TaxData.StarterRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += basicRateUsed * TaxData.BasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += intermediateRateUsed * TaxData.IntermediateRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += higherRateUsed * TaxData.HigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += additionalRateUsed * TaxData.AdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);

    tax += basicRateDividend * TaxData.DividendBasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += higherRateDividend * TaxData.DividendHigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);
    tax += additionalRateDividend * TaxData.DividendAdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);

    // tax credits
    // property tax credit

    tax -= min(tax, (taxPosition as PersonalTaxPosition).propertyTaxCredit);


    tax = Utilities.roundTax(tax);

  }

  num getBasicRateAvailable(){

    calculate();

    num basicRate = TaxData.BasicRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.StarterRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland);

    if(taxableIncome > basicRate){
      return 0;
    } else {
      return basicRate - taxableIncome;
    }


  }



    List<List<String>> narrative(List<List<String>> narrative){

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
        narrative.add(['Starter Rate','','',startRateUsed.toString(),'at ${TaxData.StarterRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%',(startRateUsed*TaxData.StarterRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }

      narrative.add(['Basic Rate','','',basicRateUsed.toString(),'at ${TaxData.BasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%',(basicRateUsed*TaxData.BasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);

      if(intermediateRateUsed > 0){
        narrative.add(['Intermediate Rate','','',intermediateRateUsed.toString(),'at ${TaxData.IntermediateRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%',(intermediateRateUsed*TaxData.IntermediateRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }

      if(higherRateUsed > 0){
        narrative.add(['Higher Rate','','',higherRateUsed.toString(),'at ${TaxData.HigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%',(higherRateUsed*TaxData.HigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
     }

      if(additionalRateUsed > 0){
        narrative.add(['Additional Rate','','',additionalRateUsed.toString(),'at ${TaxData.AdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%%',(additionalRateUsed*TaxData.AdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }

      if(dividendNilRate > 0){
        narrative.add(['Nil Rate Dividend','','',dividendNilRate.toString(),'at ${0*100}%%',(0).toString()]);
      }

      if(basicRateDividend > 0){
        narrative.add(['Basic Rate Dividend','','',basicRateDividend.toString(),'at ${TaxData.DividendBasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%%',(basicRateDividend*TaxData.DividendBasicRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }

      if(higherRateDividend > 0){
        narrative.add(['Higher Rate Dividend','','',higherRateDividend.toString(),'at ${TaxData.DividendHigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%%',(higherRateDividend*TaxData.DividendHigherRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }

      if(additionalRateDividend > 0){
        narrative.add(['Additional Rate Dividend','','',additionalRateDividend.toString(),'at ${TaxData.DividendAdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)*100}%%',(additionalRateDividend*TaxData.DividendAdditionalRate((taxPosition as PersonalTaxPosition).period.end.year, (taxPosition.entity as Person).scotland)).toString()]);
      }


      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
   }








}
