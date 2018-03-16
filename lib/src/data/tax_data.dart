import 'income_tax/income_tax_data.dart';
import 'capital_gains_tax/capital_gains_tax_data.dart';
import 'national_insurance/national_insurance_data.dart';


class TaxData{

  static num personalAllowanceDefault(int year, bool scotland) => IncomeTaxData.get(year, scotland).PersonalAllowanceDefault;

  static num starterRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).StarterRateBand;
  static num basicRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).BasicRateBand;
  static num intermediateRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).IntermediateRateBand;
  static num personalAllowanceTaperThreshold(int year, bool scotland) => IncomeTaxData.get(year, scotland).PersonalAllowanceTaperThreshold;

  static num additionalRateLimit(int year, bool scotland) => IncomeTaxData.get(year, scotland).AdditionalRateLimit;
  static num starterRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).StarterRate;
  static num basicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).BasicRate;
  static num intermediateRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).IntermediateRate;
  static num higherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).HigherRate;
  static num additionalRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).AdditionalRate;

  static num dividendNilBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendNilBand;
  static num dividendBasicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendBasicRate;
  static num dividendHigherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendHigherRate;
  static num dividendAdditionalRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendAdditionalRate;

  static num savingsStartingNilBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsStartingNilBand;
  static num savingsAllowanceBasicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsAllowanceBasicRate;
  static num savingsAllowanceHigherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsAllowanceHigherRate;


  static num capitalGainsAnnualExempt(int year) => CapitalGainsTaxData.get(year).CapitalGainsAnnualExempt;
  static num capitalGainsAnnualExemptTrustees(int year) => CapitalGainsTaxData.get(year).CapitalGainsAnnualExemptTrustees;
  static num capitalGainsBasicRateRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsBasicRateRes;
  static num capitalGainsBasicRateNonRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsBasicRateNonRes;
  static num capitalGainsHigherRateRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsHigherRateRes;
  static num capitalGainsHigherRateNonRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsHigherRateNonRes;
  static num capitalGainsEntrepreneur(int year) => CapitalGainsTaxData.get(year).CapitalGainsEntrepreneur;



  static num c1LowerEarningsLimit(int year) => NationalInsuranceData.get(year).C1LowerEarningsLimit;
  static num c1PrimaryThreshold(int year) => NationalInsuranceData.get(year).C1PrimaryThreshold;
  static num c1SecondaryThreshold(int year) => NationalInsuranceData.get(year).C1SecondaryThreshold;
  static num c1UpperAccrualPoint(int year) => NationalInsuranceData.get(year).C1UpperAccrualPoint;
  static num c1UpperEarningsLimit(int year) => NationalInsuranceData.get(year).C1UpperEarningsLimit;
  static  num c1UpperSecondaryThreshold(int year) => NationalInsuranceData.get(year).C1UpperSecondaryThreshold;
  static num c1ApprenticeUpperSecondaryThreshold(int year) => NationalInsuranceData.get(year).C1ApprenticeUpperSecondaryThreshold;

  static num c1RateToUEL(int year) => NationalInsuranceData.get(year).C1RateToUEL;
  static num c1RateAboveUEL(int year) => NationalInsuranceData.get(year).C1RateAboveUEL;
  static num c1RateContractedOut(int year) => NationalInsuranceData.get(year).C1RateContractedOut;
  static  num c1MarriedWomensRate(int year) => NationalInsuranceData.get(year).C1MarriedWomensRate;
  static num c1RateSecondary(int year) => NationalInsuranceData.get(year).C1RateSecondary;
  static num c1RateSecondaryContractedOut(int year) => NationalInsuranceData.get(year).C1RateSecondaryContractedOut;

  //class 2
  static num c2SmallProfitsThreshold(int year) => NationalInsuranceData.get(year).C2SmallProfitsThreshold;
  static num c2Cl2RatePerWeek(int year) => NationalInsuranceData.get(year).C2Cl2RatePerWeek;

  // class 4

  static num c4LowerProfitLimit(int year) => NationalInsuranceData.get(year).C4LowerProfitLimit;
  static num c4UpperProfitLimit(int year) => NationalInsuranceData.get(year).C4UpperProfitLimit;
  static num c4RateToUpperLimit(int year) => NationalInsuranceData.get(year).C4RateToUpperLimit;
  static num c4RateAboveUpperLimit(int year) => NationalInsuranceData.get(year).C4RateAboveUpperLimit;



}