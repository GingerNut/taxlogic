import 'income_tax_data.dart';

class IncomeTaxData2016 extends IncomeTaxData{

  num PersonalAllowanceDefault = 10600;
  num StarterRateBand = 0;
  num BasicRateBand = 31785;
  num IntermediateRateBand = 0;
  num PersonalAllowanceTaperThreshold = 100000;
  num AdditionalRateLimit = 150000;

  num StarterRate= 0.20;
  num BasicRate = 0.2;
  num IntermediateRate = 0.20;
  num HigherRate = 0.4;
  num AdditionalRate = 0.45;

  num DividendNilBand = 0;
  num TaxCredit = 0.10;
  num DividendBasicRate = 0.225;
  num DividendHigherRate = 0.325;
  num DividendAdditionalRate = 0.375;

  num SavingsStartingNilBand = 5000;
  num SavingsAllowanceBasicRate = 1000;
  num SavingsAllowanceHigherRate = 500;

}
