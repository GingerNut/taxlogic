import 'income_tax_data.dart';

class IncomeTaxDataScotland2019 extends IncomeTaxData{

  num PersonalAllowanceDefault = 11850;
  num StarterRateBand = 2000;
  num BasicRateBand = 10150;
  num IntermediateRateBand = 19430;
  num PersonalAllowanceTaperThreshold = 100000;
  num AdditionalRateLimit = 150000;

  num StarterRate= 0.19;
  num BasicRate = 0.2;
  num IntermediateRate = 0.21;
  num HigherRate = 0.41;
  num AdditionalRate = 0.46;

  num DividendNilBand = 2000;
  num DividendBasicRate = 0.075;
  num DividendHigherRate = 0.325;
  num DividendAdditionalRate = 0.381;

  num SavingsStartingNilBand = 5000;
  num SavingsAllowanceBasicRate = 1000;
  num SavingsAllowanceHigherRate = 500;
}
