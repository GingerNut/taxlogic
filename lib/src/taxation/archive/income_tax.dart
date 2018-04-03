import 'dart:math';
import 'package:taxlogic/src/tax_position/personal/personal_tax_position.dart';
import 'package:taxlogic/src/entities/person.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import '../data/tax_data.dart';
import 'taxation.dart';
import '../tax_position/tax_position.dart';

class IncomeTaxPosition{

  IncomeTaxPosition(PersonalTaxPosition taxPosition);




  static num calculate(PersonalTaxPosition taxPosition){

    reset(taxPosition);

    num tax = 0.0;

    num totalIncome = taxPosition.totalIncome;
       // savings
    taxPosition.savingsAllowance = totalIncome > TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) ? TaxData.savingsAllowanceHigherRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) : TaxData.savingsAllowanceBasicRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    taxPosition.savingsNilRateBand = TaxData.savingsStartingNilBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
      if(totalIncome - (taxPosition as PersonalTax2018).savings > TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){
        taxPosition.savingsNilRateBand = max(0,TaxData.savingsStartingNilBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - max(0,totalIncome - (taxPosition as PersonalTax2018).savings-TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)));
        if(taxPosition.savingsNilRateBand <0) taxPosition.savingsNilRateBand = 0;
      }


    taxPosition.taxableSavingsIncome = max(0, (taxPosition as PersonalTax2018).savings - taxPosition.savingsAllowance - taxPosition.savingsNilRateBand);
     totalIncome = totalIncome - (taxPosition as PersonalTax2018).savings + taxPosition.taxableSavingsIncome;



    num nonDividendIncome = totalIncome - taxPosition.dividend;

    // calculate personal allowance

    if(totalIncome > TaxData.PersonalAllowanceTaperThreshold((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){

      taxPosition.personalAllowance = TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - (totalIncome - TaxData.PersonalAllowanceTaperThreshold((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland))/2;
      if (taxPosition.personalAllowance < 0) taxPosition.personalAllowance = 0.0;

    } else taxPosition.personalAllowance = min(TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland), totalIncome);

    taxPosition.taxableNonDividenIncome = max(0, nonDividendIncome - taxPosition.personalAllowance);

    if((taxPosition.entity as Person).scotland){

      if(nonDividendIncome <=TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){
        taxPosition.personalAllowanceUsed = nonDividendIncome;
      } else if(taxPosition.taxableNonDividenIncome < TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){

        taxPosition.startRateUsed = taxPosition.taxableNonDividenIncome;
      } else if (taxPosition.taxableNonDividenIncome< TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){
        taxPosition.startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.basicRateUsed = taxPosition.taxableNonDividenIncome - taxPosition.startRateUsed;

      } else if(taxPosition.taxableNonDividenIncome < TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){
        taxPosition.startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.intermediateRateUsed = taxPosition.taxableNonDividenIncome - taxPosition.startRateUsed - taxPosition.basicRateUsed;
      } else if (taxPosition.taxableNonDividenIncome < TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){
        taxPosition.startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.intermediateRateUsed = TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.higherRateUsed = taxPosition.taxableNonDividenIncome - taxPosition.startRateUsed - taxPosition.basicRateUsed - taxPosition.intermediateRateUsed;
      } else {
        taxPosition.startRateUsed = TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.intermediateRateUsed = TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
        taxPosition.higherRateUsed = TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - taxPosition.startRateUsed - taxPosition.basicRateUsed - taxPosition.intermediateRateUsed;
        taxPosition.additionalRateUsed = taxPosition.taxableNonDividenIncome - TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
      }


    } else if (nonDividendIncome <= TaxData.PersonalAllowanceDefault((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){

      taxPosition.personalAllowanceUsed = nonDividendIncome;

    } else if(taxPosition.taxableNonDividenIncome < TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)) {

      taxPosition.personalAllowanceUsed = taxPosition.personalAllowance;

      taxPosition.basicRateUsed = taxPosition.taxableNonDividenIncome - taxPosition.startRateUsed;

    } else if(taxPosition.taxableNonDividenIncome < TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland)){

      taxPosition.personalAllowanceUsed = taxPosition.personalAllowance;
      taxPosition.basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
      taxPosition.higherRateUsed = taxPosition.taxableNonDividenIncome - taxPosition.basicRateUsed - taxPosition.intermediateRateUsed;;

    } else {
      taxPosition.personalAllowanceUsed = taxPosition.personalAllowance;
      taxPosition.basicRateUsed = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
      taxPosition.higherRateUsed = TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - taxPosition.basicRateUsed - taxPosition.intermediateRateUsed - taxPosition.startRateUsed;
      taxPosition.additionalRateUsed = taxPosition.taxableNonDividenIncome - TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);

    }


    // dividend tax

    num diviPersonalAllowance = taxPosition.personalAllowance - taxPosition.personalAllowanceUsed;

    num dividendRemaining = taxPosition.dividend - diviPersonalAllowance;

    num diviBasicRateLeft = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - taxPosition.basicRateUsed;
    num diviHigherRateLeft = TaxData.AdditionalRateLimit((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.StarterRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) - taxPosition.higherRateUsed;


    if(dividendRemaining < diviBasicRateLeft){
      taxPosition.basicRateDividend = dividendRemaining;
      dividendRemaining = 0;
    } else if (dividendRemaining > diviBasicRateLeft){
      taxPosition.basicRateDividend = diviBasicRateLeft;
        dividendRemaining -= diviBasicRateLeft;
    } else {
      taxPosition.basicRateDividend = dividendRemaining;
        dividendRemaining = 0;
    }

    if(dividendRemaining > diviHigherRateLeft){
      taxPosition.higherRateDividend = diviHigherRateLeft;
      dividendRemaining -= diviHigherRateLeft;
    } else {
      taxPosition.higherRateDividend = dividendRemaining;
      dividendRemaining = 0;
    }

    if(dividendRemaining > 0){
      taxPosition.additionalRateDividend = dividendRemaining;
    }

    // the dividend nil rate band


   num dividendNilRateBandRemaining = min(TaxData.DividendNilBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland), taxPosition. dividend);


    taxPosition.dividendNilRate = min(dividendNilRateBandRemaining, taxPosition.basicRateDividend);
    dividendNilRateBandRemaining -= taxPosition.dividendNilRate;
    taxPosition.basicRateDividend -= taxPosition.dividendNilRate;

    if(dividendNilRateBandRemaining > 0){
      num extraNilRate = min (dividendNilRateBandRemaining, taxPosition.higherRateDividend);
      taxPosition.dividendNilRate += extraNilRate;
      dividendNilRateBandRemaining -= extraNilRate;
      taxPosition.higherRateDividend -= extraNilRate;
    }

    if(dividendNilRateBandRemaining > 0){
      num extraNilRate = min(dividendNilRateBandRemaining, taxPosition.additionalRateDividend);
      taxPosition.dividendNilRate += extraNilRate;
      taxPosition.additionalRateDividend -= extraNilRate;
    }

    taxPosition.taxableIncome = totalIncome - taxPosition.personalAllowance;

    tax = 0.0;
    tax += taxPosition.startRateUsed * TaxData.StarterRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.basicRateUsed * TaxData.BasicRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.intermediateRateUsed * TaxData.IntermediateRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.higherRateUsed * TaxData.HigherRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.additionalRateUsed * TaxData.AdditionalRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);

    tax += taxPosition.basicRateDividend * TaxData.DividendBasicRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.higherRateDividend * TaxData.DividendHigherRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);
    tax += taxPosition.additionalRateDividend * TaxData.DividendAdditionalRate((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);

    // tax credits
    // property tax credit

    tax -= tax.clamp(tax, taxPosition.propertyTaxCredit);


    tax = Utilities.roundTax(tax);

    return tax;
  }

  num getBasicRateAvailable(){

    num basicRate = TaxData.BasicRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland) + TaxData.StarterRateBand(period.end.year, taxPosition.person.scotland) + TaxData.IntermediateRateBand((taxPosition as PersonalTax2018).period.end.year, (taxPosition.entity as Person).scotland);

    if(taxableIncome > basicRate){
      return 0;
    } else {
      return basicRate - taxableIncome;
    }


  }











}
