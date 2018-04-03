
import '../tax_position.dart';
import 'dart:math';
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/entities/entity.dart';
import '../../data/tax_data.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import 'package:taxlogic/taxlogic.dart';


class PersonalTaxPosition extends TaxPosition{
  PersonalTaxPosition(this.person, this.year) : super(person){
    period = new Period (new Date(6,4,year-1), new Date (5,4,year));
  }

  final Person person;
  final int year;
  num basicRateBeforeDividends;

  num personalAllowance;
  num personalAllowanceUsed;
  num taxableSavingsIncome;

  num taxableIncome;
  num taxableNonDividenIncome;
  num savingsRateUsed;
  num savingsAllowanceUsed;
  num startRateUsed;
  num basicRateUsed;
  num intermediateRateUsed;
  num higherRateUsed;
  num additionalRateUsed ;

  num dividendNilRate ;
  num basicRateDividend ;
  num higherRateDividend ;
  num additionalRateDividend ;

  num savingsAllowance;
  num savingsNilRateBand;

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

  num cgtBasicRateRes = 0;
  num cgtBasicRateNonRes = 0;
  num cgtBasicRateEnt = 0;
  num cgtHigherRateRes = 0;
  num cgtHigherRateNonRes = 0;
  num cgtHigherRateEnt = 0;

  num earnings =0;
  num trade =0;
  num savings = 0;
  num dividend =0;
  num propertyIncome = 0;
  num propertyTaxCredit = 0;
  
  num _tax = 0;
  num _totalIncome;

  num get totalIncome{
    if(_totalIncome != null) return _totalIncome;

    income.forEach((inc){
      inc.income;
    });

    _totalIncome = earnings + trade + savings + dividend;

    return _totalIncome;
  }

  num get taxCredit {
    num taxCredit = 0;

    income.forEach((inc){
      taxCredit += inc.taxCredit;
    });
    return taxCredit;
  }

  num get taxDeducted {
    num taxDeducted = 0;

    income.forEach((inc){
      taxDeducted += inc.taxDeducted;
    });
    return taxDeducted;
  }

  num get tax{
    
    reset();

    incomeTax();

    dividendTax();

    nationalInsurance();

    refreshDisposals();

    allocateLosses();

    capitalGainsTax();

    _tax -= taxCredit.clamp(0,taxCredit);

    _tax -= taxDeducted;

    _tax = Utilities.roundTax(_tax);

    return _tax;
  }


  
  reset(){
    _tax = 0;
    personalAllowanceUsed = 0;
    taxableSavingsIncome = 0;
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

  num incomeTax() {

    // savings
    savingsAllowance = totalIncome > TaxData.PersonalAllowanceDefault(
        period.end.year,
        person.scotland) + TaxData.BasicRateBand(
        period.end.year,
        person.scotland) ? TaxData.savingsAllowanceHigherRate(
        period.end.year,
        person.scotland) : TaxData.savingsAllowanceBasicRate(
        period.end.year,
        person.scotland);
    savingsNilRateBand = TaxData.savingsStartingNilBand(
        period.end.year,
        person.scotland);
    if (totalIncome - savings >
        TaxData.PersonalAllowanceDefault(
            period.end.year,
            person.scotland)) {
      savingsNilRateBand = max(0, TaxData.savingsStartingNilBand(
          period.end.year,
          person.scotland) - max(0,
          totalIncome - savings -
              TaxData.PersonalAllowanceDefault(
                  period.end.year,
                  person.scotland)));
      if (savingsNilRateBand < 0) savingsNilRateBand = 0;
    }


    taxableSavingsIncome = max(0,
        savings - savingsAllowance -
            savingsNilRateBand);

    _totalIncome = totalIncome - savings +
        taxableSavingsIncome;


    num nonDividendIncome = totalIncome - dividend;

    // calculate personal allowance

    if (totalIncome > TaxData.PersonalAllowanceTaperThreshold(
        period.end.year,
        person.scotland)) {
      personalAllowance = TaxData.PersonalAllowanceDefault(
          period.end.year,
          person.scotland) - (totalIncome -
          TaxData.PersonalAllowanceTaperThreshold(
              period.end.year,
              person.scotland)) / 2;
      if (personalAllowance < 0) personalAllowance = 0.0;
    } else
      personalAllowance = min(TaxData.PersonalAllowanceDefault(
          period.end.year,
          person.scotland), totalIncome);

    taxableNonDividenIncome = max(0, nonDividendIncome - personalAllowance);

    if (person.scotland) {
      if (nonDividendIncome <= TaxData.PersonalAllowanceDefault(
          period.end.year,
          person.scotland)) {
        personalAllowanceUsed = nonDividendIncome;
      } else if (taxableNonDividenIncome < TaxData.StarterRateBand(
          period.end.year,
          person.scotland)) {
        startRateUsed = taxableNonDividenIncome;
      } else if (taxableNonDividenIncome < TaxData.StarterRateBand(
          period.end.year,
          person.scotland) + TaxData.BasicRateBand(
          period.end.year,
          person.scotland)) {
        startRateUsed = TaxData.StarterRateBand(
            period.end.year,
            person.scotland);
        basicRateUsed = taxableNonDividenIncome - startRateUsed;
      } else if (taxableNonDividenIncome < TaxData.StarterRateBand(
          period.end.year,
          person.scotland) + TaxData.BasicRateBand(
          period.end.year,
          person.scotland) + TaxData.IntermediateRateBand(
          period.end.year,
          person.scotland)) {
        startRateUsed = TaxData.StarterRateBand(
            period.end.year,
            person.scotland);
        basicRateUsed = TaxData.BasicRateBand(
            period.end.year,
            person.scotland);
        intermediateRateUsed =
            taxableNonDividenIncome - startRateUsed - basicRateUsed;
      } else if (taxableNonDividenIncome < TaxData.AdditionalRateLimit(
          period.end.year,
          person.scotland)) {
        startRateUsed = TaxData.StarterRateBand(
            period.end.year,
            person.scotland);
        basicRateUsed = TaxData.BasicRateBand(
            period.end.year,
            person.scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand(
            period.end.year,
            person.scotland);
        higherRateUsed =
            taxableNonDividenIncome - startRateUsed - basicRateUsed -
                intermediateRateUsed;
      } else {
        startRateUsed = TaxData.StarterRateBand(
            period.end.year,
            person.scotland);
        basicRateUsed = TaxData.BasicRateBand(
            period.end.year,
            person.scotland);
        intermediateRateUsed = TaxData.IntermediateRateBand(
            period.end.year,
            person.scotland);
        higherRateUsed = TaxData.AdditionalRateLimit(
            period.end.year,
            person.scotland) - startRateUsed - basicRateUsed -
            intermediateRateUsed;
        additionalRateUsed = taxableNonDividenIncome -
            TaxData.AdditionalRateLimit(
                period.end.year,
                person.scotland);
      }
    } else if (nonDividendIncome <= TaxData.PersonalAllowanceDefault(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = nonDividendIncome;
    } else if (taxableNonDividenIncome < TaxData.BasicRateBand(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = personalAllowance;

      basicRateUsed = taxableNonDividenIncome - startRateUsed;
    } else if (taxableNonDividenIncome < TaxData.AdditionalRateLimit(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand(
          period.end.year,
          person.scotland);
      higherRateUsed =
          taxableNonDividenIncome - basicRateUsed - intermediateRateUsed;
      ;
    } else {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand(
          period.end.year,
          person.scotland);
      higherRateUsed = TaxData.AdditionalRateLimit(
          period.end.year,
          person.scotland) - basicRateUsed - intermediateRateUsed -
          startRateUsed;
      additionalRateUsed = taxableNonDividenIncome -
          TaxData.AdditionalRateLimit(
              period.end.year,
              person.scotland);
    }

    taxableIncome = totalIncome - personalAllowance;

    _tax = 0.0;
    _tax += startRateUsed * TaxData.StarterRate(period.end.year, person.scotland);
    _tax += basicRateUsed * TaxData.BasicRate(period.end.year, person.scotland);
    _tax += intermediateRateUsed * TaxData.IntermediateRate(period.end.year, person.scotland);
    _tax += higherRateUsed * TaxData.HigherRate(period.end.year, person.scotland);
    _tax += additionalRateUsed * TaxData.AdditionalRate(period.end.year, person.scotland);


  }

  num dividendTax(){
      // dividend tax

      num diviPersonalAllowance = personalAllowance - personalAllowanceUsed;

      num dividendRemaining = dividend - diviPersonalAllowance;

      num diviBasicRateLeft = TaxData.BasicRateBand(period.end.year, person.scotland) + TaxData.StarterRateBand(period.end.year, person.scotland) + TaxData.IntermediateRateBand(period.end.year, person.scotland) - basicRateUsed;
      num diviHigherRateLeft = TaxData.AdditionalRateLimit(period.end.year, person.scotland) - TaxData.StarterRateBand(period.end.year, person.scotland) - TaxData.BasicRateBand(period.end.year, person.scotland) - TaxData.IntermediateRateBand(period.end.year, person.scotland) - higherRateUsed;


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


      num dividendNilRateBandRemaining = min(TaxData.DividendNilBand(period.end.year, person.scotland),  dividend);


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

      _tax += basicRateDividend * TaxData.DividendBasicRate(period.end.year, person.scotland);
      _tax += higherRateDividend * TaxData.DividendHigherRate(period.end.year, person.scotland);
      _tax += additionalRateDividend * TaxData.DividendAdditionalRate(period.end.year, person.scotland);

    }

  nationalInsurance(){

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

    if(earnings > 0) Class1();

    if(trade > 0) Class4();

    Class2();

    // interraction


    nicClass1p = Utilities.roundTax(nicClass1p);
    nicClass1s = Utilities.roundTax(nicClass1s);
    nicClass2 = Utilities.roundTax(nicClass2);
    nicClass3 = Utilities.roundTax(nicClass3);
    nicClass4 = Utilities.roundTax(nicClass4);

  }

  void Class1(){
    if(earnings < TaxData.C1PrimaryThreshold(period.end.year)){

    } else if(earnings < TaxData.C1UpperEarningsLimit(period.end.year)){
      earningsBetweenPTandUEL = earnings - TaxData.C1PrimaryThreshold(period.end.year);
    } else {
      earningsBetweenPTandUEL = TaxData.C1UpperEarningsLimit(period.end.year) - TaxData.C1PrimaryThreshold(period.end.year);
      earningsAboveUEL = earnings - TaxData.C1UpperEarningsLimit(period.end.year);
    }

    if(earnings > TaxData.C1SecondaryThreshold(period.end.year)) {
      earningsAboveSecondaryThreshold = earnings - TaxData.C1SecondaryThreshold(period.end.year);

    }




    nicClass1p = 0;
    nicClass1p += earningsBetweenPTandUEL * TaxData.C1RateToUEL(period.end.year);
    nicClass1p += earningsAboveUEL * TaxData.C1RateAboveUEL(period.end.year);

    nicClass1s = 0;
    nicClass1s += earningsAboveSecondaryThreshold * TaxData.C1RateSecondary(period.end.year);


  }

  Class2(){

  }

  Class4(){

    if(trade < TaxData.C4UpperProfitLimit(period.end.year)){

      if(trade > TaxData.C4LowerProfitLimit(period.end.year)) tradeAboveLowerLimit = trade - TaxData.C4LowerProfitLimit(period.end.year);
    } else {

      tradeAboveLowerLimit = TaxData.C4UpperProfitLimit(period.end.year) - TaxData.C4LowerProfitLimit(period.end.year);
      tradeAboveUpperLimit = trade - TaxData.C4UpperProfitLimit(period.end.year);
    }

    nicClass4 = 0;
    nicClass4 += tradeAboveLowerLimit * TaxData.C4RateToUpperLimit(period.end.year);
    nicClass4 += tradeAboveUpperLimit * TaxData.C4RateAboveUpperLimit(period.end.year);
  }

  void allocateLosses(){
    num lossesToAllocate = totalLossUsed;

    //sort disposals into loss priority - residential first, non residential next then entrepreneur

    List<ChargeableAsset> residential = new List();
    List<ChargeableAsset> nonResidential = new List();
    List<ChargeableAsset> entrepreneur = new List();

   disposals.forEach((asset){
      if(asset.taxableGain > 0){
        if(asset.residentialProperty) residential.add(asset);
        else if (asset.entrepreneurRelief) entrepreneur.add(asset);
        else nonResidential.add(asset);
      }

    });

    List<ChargeableAsset> priority;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(lossesToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(lossesToAllocate < asset.taxableGain){
          asset.lossAllocated = lossesToAllocate;
          lossesToAllocate = 0;
        } else {
          asset.lossAllocated = asset.taxableGain;
          lossesToAllocate -= asset.lossAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }

    // allocate annual exemption

    num annualExemptionToAllocate = annualExemption;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(annualExemptionToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(annualExemptionToAllocate < asset.taxableGain - asset.lossAllocated){
          asset.annualExemptionAllocated = annualExemptionToAllocate;
          annualExemptionToAllocate = 0;
        } else {
          asset.annualExemptionAllocated = asset.taxableGain - asset.lossAllocated;
          annualExemptionToAllocate -= asset.annualExemptionAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }



    // allocate gains to rates of tax
    num basicRateAmount = basicRateAvailable;

    num basicRateToAllocate = basicRateAmount;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(basicRateToAllocate > 0 && priority != null){

      priority.forEach((asset){
        if(basicRateToAllocate < asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated){
          asset.basicRateAllocated = basicRateToAllocate;
          basicRateToAllocate = 0;
        } else {
          asset.basicRateAllocated = asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated;
          basicRateToAllocate -= asset.basicRateAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }

  }

  num capitalGainsTax() {
    disposals.forEach((asset){

      if(asset.residentialProperty){
        cgtBasicRateRes += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated > asset.basicRateAllocated){
          cgtHigherRateRes += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }

      } else if (asset.entrepreneurRelief){

        cgtBasicRateEnt += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated> asset.basicRateAllocated){
          cgtHigherRateEnt += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }

      } else {

        cgtBasicRateNonRes += asset.basicRateAllocated;
        if(asset.taxableGain - asset.lossAllocated - asset.annualExemptionAllocated > asset.basicRateAllocated){
          cgtHigherRateNonRes += asset.taxableGain - asset.lossAllocated - asset.basicRateAllocated - asset.annualExemptionAllocated;
        }
      }
    });

    num tax = 0;

    tax += cgtBasicRateRes * TaxData.CapitalGainsBasicRateRes(period.end.year);
    tax += cgtBasicRateNonRes * TaxData.CapitalGainsBasicRateNonRes(period.end.year);
    tax +=  cgtBasicRateEnt * TaxData.CapitalGainsEntrepreneur(period.end.year);
    tax +=  cgtHigherRateRes * TaxData.CapitalGainsHigherRateRes(period.end.year);
    tax +=  cgtHigherRateNonRes * TaxData.CapitalGainsHigherRateNonRes(period.end.year);
    tax +=  cgtHigherRateEnt * TaxData.CapitalGainsEntrepreneur(period.end.year);

    tax = Utilities.roundTax(tax);

    return tax;
  }

  num get basicRateAvailable{

    num basicRate = TaxData.BasicRateBand(period.end.year, person.scotland) + TaxData.StarterRateBand(period.end.year, person.scotland) + TaxData.IntermediateRateBand(period.end.year, person.scotland);

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
        narrative.add(['Starter Rate','','',startRateUsed.toString(),'at ${TaxData.StarterRate(period.end.year, person.scotland)*100}%',(startRateUsed*TaxData.StarterRate(period.end.year, person.scotland)).toString()]);
      }

      narrative.add(['Basic Rate','','',basicRateUsed.toString(),'at ${TaxData.BasicRate(period.end.year, person.scotland)*100}%',(basicRateUsed*TaxData.BasicRate(period.end.year, person.scotland)).toString()]);

      if(intermediateRateUsed > 0){
        narrative.add(['Intermediate Rate','','',intermediateRateUsed.toString(),'at ${TaxData.IntermediateRate(period.end.year, person.scotland)*100}%',(intermediateRateUsed*TaxData.IntermediateRate(period.end.year, person.scotland)).toString()]);
      }

      if(higherRateUsed > 0){
        narrative.add(['Higher Rate','','',higherRateUsed.toString(),'at ${TaxData.HigherRate(period.end.year, person.scotland)*100}%',(higherRateUsed*TaxData.HigherRate(period.end.year, person.scotland)).toString()]);
      }

      if(additionalRateUsed > 0){
        narrative.add(['Additional Rate','','',additionalRateUsed.toString(),'at ${TaxData.AdditionalRate(period.end.year, person.scotland)*100}%%',(additionalRateUsed*TaxData.AdditionalRate(period.end.year, person.scotland)).toString()]);
      }

      if(dividendNilRate > 0){
        narrative.add(['Nil Rate Dividend','','',dividendNilRate.toString(),'at ${0*100}%%',(0).toString()]);
      }

      if(basicRateDividend > 0){
        narrative.add(['Basic Rate Dividend','','',basicRateDividend.toString(),'at ${TaxData.DividendBasicRate(period.end.year, person.scotland)*100}%%',(basicRateDividend*TaxData.DividendBasicRate(period.end.year, person.scotland)).toString()]);
      }

      if(higherRateDividend > 0){
        narrative.add(['Higher Rate Dividend','','',higherRateDividend.toString(),'at ${TaxData.DividendHigherRate(period.end.year, person.scotland)*100}%%',(higherRateDividend*TaxData.DividendHigherRate(period.end.year, person.scotland)).toString()]);
      }

      if(additionalRateDividend > 0){
        narrative.add(['Additional Rate Dividend','','',additionalRateDividend.toString(),'at ${TaxData.DividendAdditionalRate(period.end.year, person.scotland)*100}%%',(additionalRateDividend*TaxData.DividendAdditionalRate(period.end.year, person.scotland)).toString()]);
      }


      narrative.add(['Total payable','','','','',tax.toString(),]);

    }

    return narrative;
  }


}