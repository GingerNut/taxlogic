
import '../tax_position.dart';
import 'dart:math';
import 'package:taxlogic/src/accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/activity/lending/lending_activity.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import '../../data/tax_data.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import 'package:taxlogic/taxlogic.dart';


class PersonalTaxPosition extends TaxPosition{
  PersonalTaxPosition(this.person, this.year) : super(person){
    period = new Period (new Date(6,4,year-1), new Date (5,4,year));
    }

  final Person person;
  final int year;

  bool valid = false;

  num tradeIncome;
  num earningsIncome;
  num dividendIncome;
  num savingsIncome;
  num otherIncome;
  num propertyIncome;

  num basicRateBeforeDividends;

  num personalAllowance;
  num personalAllowanceUsed;
  num taxableSavingsIncome;

  num taxableIncome;
  num taxableNonDividendIncome;
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

  num nicClass1p;
  num nicClass1s;
  num nicClass2;
  num nicClass3;
  num nicClass4;

  num cgtBasicRateRes ;
  num cgtBasicRateNonRes;
  num cgtBasicRateEnt ;
  num cgtHigherRateRes ;
  num cgtHigherRateNonRes ;
  num cgtHigherRateEnt ;
  num capitalGainsTaxPayable ;
 
  num _tax = 0;
  num _totalIncomeAdjstedForSavings;

  num get totalIncome{

    _totalIncomeAdjstedForSavings = 0;
    savingsIncome = 0;
    earningsIncome =0;
    tradeIncome = 0;
    dividendIncome = 0;
    otherIncome = 0;
    propertyIncome = 0;

    person.activities.forEach( (activity) {

      Income inc = activity.getIncome(this);

      _totalIncomeAdjstedForSavings += inc.income;

      if(inc.activity is Employment) earningsIncome += inc.income;
      else if(inc.activity is Trade) tradeIncome += inc.income;
      else if(inc.activity is Savings) savingsIncome += inc.income;
      else if(inc.activity is LendingActivity) savingsIncome += inc.income;
      else if (inc.activity is ShareHolding ) dividendIncome += inc.income;
      else if(inc.activity is PropertyBusiness) propertyIncome += inc.income;
      else otherIncome += inc.income;
    }  );

    valid = true;

    return _totalIncomeAdjstedForSavings;
  }
  
  num get taxCredit {
    num _taxCredit = 0;

    income.forEach((inc){

      if(inc != null){
        _taxCredit += inc.taxCredit;
      }
    });

    return _taxCredit;
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

    analyseDisposals();

    allocateLosses();

    _tax -= taxCredit.clamp(0,_tax);

    _tax += capitalGainsTax();

    _tax -= taxDeducted;

    _tax = Utilities.roundTax(_tax);

    return _tax;
  }



  reset(){
    _tax = 0;
    personalAllowanceUsed = 0;
    taxableSavingsIncome = 0;
    taxableIncome = 0;
    taxableNonDividendIncome = 0;
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

    if (totalIncome - savingsIncome >
        TaxData.PersonalAllowanceDefault(
            period.end.year,
            person.scotland)) {
      savingsNilRateBand = max(0, TaxData.savingsStartingNilBand(
          period.end.year,
          person.scotland) - max(0,
          totalIncome - savingsIncome -
              TaxData.PersonalAllowanceDefault(
                  period.end.year,
                  person.scotland)));
      if (savingsNilRateBand < 0) savingsNilRateBand = 0;
    }


    taxableSavingsIncome = max(0,
        savingsIncome - savingsAllowance -
            savingsNilRateBand);

    _totalIncomeAdjstedForSavings = totalIncome - savingsIncome +
        taxableSavingsIncome;


    num nonDividendIncome = _totalIncomeAdjstedForSavings - dividendIncome;

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

    taxableNonDividendIncome = max(0, nonDividendIncome - personalAllowance);

    if (person.scotland) {
      if (nonDividendIncome <= TaxData.PersonalAllowanceDefault(
          period.end.year,
          person.scotland)) {
        personalAllowanceUsed = nonDividendIncome;
      } else if (taxableNonDividendIncome < TaxData.StarterRateBand(
          period.end.year,
          person.scotland)) {
        startRateUsed = taxableNonDividendIncome;
      } else if (taxableNonDividendIncome < TaxData.StarterRateBand(
          period.end.year,
          person.scotland) + TaxData.BasicRateBand(
          period.end.year,
          person.scotland)) {
        startRateUsed = TaxData.StarterRateBand(
            period.end.year,
            person.scotland);
        basicRateUsed = taxableNonDividendIncome - startRateUsed;
      } else if (taxableNonDividendIncome < TaxData.StarterRateBand(
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
            taxableNonDividendIncome - startRateUsed - basicRateUsed;
      } else if (taxableNonDividendIncome < TaxData.AdditionalRateLimit(
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
            taxableNonDividendIncome - startRateUsed - basicRateUsed -
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
        additionalRateUsed = taxableNonDividendIncome -
            TaxData.AdditionalRateLimit(
                period.end.year,
                person.scotland);
      }
    } else if (nonDividendIncome <= TaxData.PersonalAllowanceDefault(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = nonDividendIncome;
    } else if (taxableNonDividendIncome < TaxData.BasicRateBand(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = personalAllowance;

      basicRateUsed = taxableNonDividendIncome - startRateUsed;
    } else if (taxableNonDividendIncome < TaxData.AdditionalRateLimit(
        period.end.year,
        person.scotland)) {
      personalAllowanceUsed = personalAllowance;
      basicRateUsed = TaxData.BasicRateBand(
          period.end.year,
          person.scotland);
      higherRateUsed =
          taxableNonDividendIncome - basicRateUsed - intermediateRateUsed;
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
      additionalRateUsed = taxableNonDividendIncome -
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

      num dividendRemaining = dividendIncome - diviPersonalAllowance;

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


      num dividendNilRateBandRemaining = min(TaxData.DividendNilBand(period.end.year, person.scotland),  dividendIncome);


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

    if(earningsIncome > 0) Class1();

    if(tradeIncome > 0) Class4();

    Class2();

    // interraction


    nicClass1p = Utilities.roundTax(nicClass1p);
    nicClass1s = Utilities.roundTax(nicClass1s);
    nicClass2 = Utilities.roundTax(nicClass2);
    nicClass3 = Utilities.roundTax(nicClass3);
    nicClass4 = Utilities.roundTax(nicClass4);

  }

  void Class1(){
    if(earningsIncome < TaxData.C1PrimaryThreshold(period.end.year)){

    } else if(earningsIncome < TaxData.C1UpperEarningsLimit(period.end.year)){
      earningsBetweenPTandUEL = earningsIncome- TaxData.C1PrimaryThreshold(period.end.year);
    } else {
      earningsBetweenPTandUEL = TaxData.C1UpperEarningsLimit(period.end.year) - TaxData.C1PrimaryThreshold(period.end.year);
      earningsAboveUEL = earningsIncome- TaxData.C1UpperEarningsLimit(period.end.year);
    }

    if(earningsIncome> TaxData.C1SecondaryThreshold(period.end.year)) {
      earningsAboveSecondaryThreshold = earningsIncome- TaxData.C1SecondaryThreshold(period.end.year);

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

    if(tradeIncome < TaxData.C4UpperProfitLimit(period.end.year)){

      if(tradeIncome > TaxData.C4LowerProfitLimit(period.end.year)) tradeAboveLowerLimit = tradeIncome - TaxData.C4LowerProfitLimit(period.end.year);
    } else {

      tradeAboveLowerLimit = TaxData.C4UpperProfitLimit(period.end.year) - TaxData.C4LowerProfitLimit(period.end.year);
      tradeAboveUpperLimit = tradeIncome - TaxData.C4UpperProfitLimit(period.end.year);
    }

    nicClass4 = 0;
    nicClass4 += tradeAboveLowerLimit * TaxData.C4RateToUpperLimit(period.end.year);
    nicClass4 += tradeAboveUpperLimit * TaxData.C4RateAboveUpperLimit(period.end.year);
  }

  void allocateLosses(){
    num lossesToAllocate = totalLossUsed;

    //sort disposals into loss priority - residential first, non residential next then entrepreneur

    List<Transaction> residential = new List();
    List<Transaction> nonResidential = new List();
    List<Transaction> entrepreneur = new List();

   disposals.forEach((disposal){
      if(disposal.taxableGain > 0){
        if(disposal.asset is ResidentialProperty) residential.add(disposal);
        else if ((disposal.asset as ChargeableAsset).entrepreneurRelief) entrepreneur.add(disposal);
        else nonResidential.add(disposal);
      }

    });

    List<Transaction> priority;

    if(residential.length > 0) priority = residential;
    else if (nonResidential.length > 0) priority = nonResidential;
    else priority = entrepreneur;

    while(lossesToAllocate > 0 && priority != null){

      priority.forEach((disposal){
        if(lossesToAllocate < disposal.taxableGain){
          disposal.lossAllocated = lossesToAllocate;
          lossesToAllocate = 0;
        } else {
          disposal.lossAllocated = disposal.taxableGain;
          lossesToAllocate -= disposal.lossAllocated;
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

      priority.forEach((disposal){
        if(annualExemptionToAllocate < disposal.taxableGain - disposal.lossAllocated){
          disposal.annualExemptionAllocated = annualExemptionToAllocate;
          annualExemptionToAllocate = 0;
        } else {
          disposal.annualExemptionAllocated = disposal.taxableGain - disposal.lossAllocated;
          annualExemptionToAllocate -= disposal.annualExemptionAllocated;
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

      priority.forEach((disposal){
        if(basicRateToAllocate < disposal.taxableGain - disposal.lossAllocated - disposal.annualExemptionAllocated){
          disposal.basicRateAllocated = basicRateToAllocate;
          basicRateToAllocate = 0;
        } else {
          disposal.basicRateAllocated = disposal.taxableGain - disposal.lossAllocated - disposal.annualExemptionAllocated;
          basicRateToAllocate -= disposal.basicRateAllocated;
        }

      });

      if(priority == residential) priority = nonResidential;
      else if(priority == nonResidential) priority = entrepreneur;
      else priority = null;
    }

  }

  num capitalGainsTax() {

    cgtBasicRateRes = 0;
    cgtBasicRateNonRes = 0;
    cgtBasicRateEnt = 0;
    cgtHigherRateRes = 0;
    cgtHigherRateNonRes = 0;
    cgtHigherRateEnt = 0;

    disposals.forEach((disposal){

      if(disposal.asset is ResidentialProperty){
        cgtBasicRateRes += disposal.basicRateAllocated;
        if(disposal.taxableGain- disposal.lossAllocated - disposal.annualExemptionAllocated > disposal.basicRateAllocated){
          cgtHigherRateRes += disposal.taxableGain- disposal.lossAllocated - disposal.basicRateAllocated - disposal.annualExemptionAllocated;
        }

      } else if ((disposal.asset as ChargeableAsset).entrepreneurRelief){

        cgtBasicRateEnt += disposal.basicRateAllocated;
        if(disposal.taxableGain- disposal.lossAllocated - disposal.annualExemptionAllocated> disposal.basicRateAllocated){
          cgtHigherRateEnt += disposal.taxableGain- disposal.lossAllocated - disposal.basicRateAllocated - disposal.annualExemptionAllocated;
        }

      } else {
        cgtBasicRateNonRes += disposal.basicRateAllocated;
        if(disposal.taxableGain- disposal.lossAllocated - disposal.annualExemptionAllocated > disposal.basicRateAllocated){
          cgtHigherRateNonRes += disposal.taxableGain- disposal.lossAllocated - disposal.basicRateAllocated - disposal.annualExemptionAllocated;
        }
      }
    });

    capitalGainsTaxPayable = 0;

    capitalGainsTaxPayable += cgtBasicRateRes * TaxData.CapitalGainsBasicRateRes(period.end.year);
    capitalGainsTaxPayable += cgtBasicRateNonRes * TaxData.CapitalGainsBasicRateNonRes(period.end.year);
    capitalGainsTaxPayable +=  cgtBasicRateEnt * TaxData.CapitalGainsEntrepreneur(period.end.year);
    capitalGainsTaxPayable +=  cgtHigherRateRes * TaxData.CapitalGainsHigherRateRes(period.end.year);
    capitalGainsTaxPayable +=  cgtHigherRateNonRes * TaxData.CapitalGainsHigherRateNonRes(period.end.year);
    capitalGainsTaxPayable +=  cgtHigherRateEnt * TaxData.CapitalGainsEntrepreneur(period.end.year);

    capitalGainsTaxPayable = Utilities.roundTax(capitalGainsTaxPayable);

    return capitalGainsTaxPayable;
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