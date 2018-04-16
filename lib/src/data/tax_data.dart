import 'income_tax/income_tax_data.dart';
import 'capital_gains_tax/capital_gains_tax_data.dart';
import 'national_insurance/national_insurance_data.dart';
import 'company_tax/company_tax_data.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../entities/entity.dart';
import 'capital_allowances/capital_allowances.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'interest/overdue_interest.dart';
import 'capital_gains_tax/indexation.dart';
import 'company_car/company_car.dart';

class TaxData{

  static num PersonalAllowanceDefault(int year, bool scotland) => IncomeTaxData.get(year, scotland).PersonalAllowanceDefault;

  static num StarterRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).StarterRateBand;
  static num BasicRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).BasicRateBand;
  static num IntermediateRateBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).IntermediateRateBand;
  static num PersonalAllowanceTaperThreshold(int year, bool scotland) => IncomeTaxData.get(year, scotland).PersonalAllowanceTaperThreshold;

  static num AdditionalRateLimit(int year, bool scotland) => IncomeTaxData.get(year, scotland).AdditionalRateLimit;
  static num StarterRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).StarterRate;
  static num BasicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).BasicRate;
  static num IntermediateRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).IntermediateRate;
  static num HigherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).HigherRate;
  static num AdditionalRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).AdditionalRate;

  static num DividendNilBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendNilBand;
  static num DividendBasicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendBasicRate;
  static num DividendHigherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendHigherRate;
  static num DividendAdditionalRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).DividendAdditionalRate;

  static num savingsStartingNilBand(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsStartingNilBand;
  static num savingsAllowanceBasicRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsAllowanceBasicRate;
  static num savingsAllowanceHigherRate(int year, bool scotland) => IncomeTaxData.get(year, scotland).SavingsAllowanceHigherRate;

  //cgt

  static num CapitalGainsAnnualExempt(int year, Entity entity) {
    if(entity.type == Entity.COMPANY) return 0;

    num annualExemption = CapitalGainsTaxData.get(year).CapitalGainsAnnualExempt;

    if(entity.type == Entity.TRUST) return annualExemption / 2;

    return annualExemption;
  }

  static num CapitalGainsBasicRateRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsBasicRateRes;
  static num CapitalGainsBasicRateNonRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsBasicRateNonRes;
  static num CapitalGainsHigherRateRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsHigherRateRes;
  static num CapitalGainsHigherRateNonRes(int year) => CapitalGainsTaxData.get(year).CapitalGainsHigherRateNonRes;
  static num CapitalGainsEntrepreneur(int year) => CapitalGainsTaxData.get(year).CapitalGainsEntrepreneur;

// nic

  static num C1LowerEarningsLimit(int year) => NationalInsuranceData.get(year).C1LowerEarningsLimit;
  static num C1PrimaryThreshold(int year) => NationalInsuranceData.get(year).C1PrimaryThreshold;
  static num C1SecondaryThreshold(int year) => NationalInsuranceData.get(year).C1SecondaryThreshold;
  static num C1UpperAccrualPoint(int year) => NationalInsuranceData.get(year).C1UpperAccrualPoint;
  static num C1UpperEarningsLimit(int year) => NationalInsuranceData.get(year).C1UpperEarningsLimit;
  static num C1UpperSecondaryThreshold(int year) => NationalInsuranceData.get(year).C1UpperSecondaryThreshold;
  static num C1ApprenticeUpperSecondaryThreshold(int year) => NationalInsuranceData.get(year).C1ApprenticeUpperSecondaryThreshold;

  static num C1RateToUEL(int year) => NationalInsuranceData.get(year).C1RateToUEL;
  static num C1RateAboveUEL(int year) => NationalInsuranceData.get(year).C1RateAboveUEL;
  static num C1RateContractedOut(int year) => NationalInsuranceData.get(year).C1RateContractedOut;
  static num C1MarriedWomensRate(int year) => NationalInsuranceData.get(year).C1MarriedWomensRate;
  static num C1RateSecondary(int year) => NationalInsuranceData.get(year).C1RateSecondary;
  static num C1RateSecondaryContractedOut(int year) => NationalInsuranceData.get(year).C1RateSecondaryContractedOut;

  //class 2
  static num C2SmallProfitsThreshold(int year) => NationalInsuranceData.get(year).C2SmallProfitsThreshold;
  static num C2Cl2RatePerWeek(int year) => NationalInsuranceData.get(year).C2Cl2RatePerWeek;

  // class 4

  static num C4LowerProfitLimit(int year) => NationalInsuranceData.get(year).C4LowerProfitLimit;
  static num C4UpperProfitLimit(int year) => NationalInsuranceData.get(year).C4UpperProfitLimit;
  static num C4RateToUpperLimit(int year) => NationalInsuranceData.get(year).C4RateToUpperLimit;
  static num C4RateAboveUpperLimit(int year) => NationalInsuranceData.get(year).C4RateAboveUpperLimit;

  //coproariton tax

  static num CompanyMainRate(Date date) => CompanyTaxData.getMainRate(date);
  static List<NumPeriod> CompanyRatePeriods(Period period) => CompanyTaxData.getRatePeriods(period);

  static num AnnualInvestmentAllowance(Date date, Entity entity) => CapitalAllowances.getAIA(date, entity);
  static List<NumPeriod> AnnualInvestmentAllowancePeriods(Period period, Entity entity) => CapitalAllowances.getAIAPeriods(period, entity);
  static num AnnualInvestmentOverallRate(Period period, Entity entity) => CapitalAllowances.getOverallAIA(period, entity);

  static num OverdueInterestTotal(Period period) => OverdueInterest.overdueInterest.overallAmount(period);

  static num IndexationFactor(Date purchase, Date sale) => Indexation.indexation(purchase, sale);


  // company car

  static num CompanyCarRate(int year, int engineType, num CO2) => CompanyCarRates.get(year, engineType).table.rate(CO2.toInt())/100;
}