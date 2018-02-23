import 'income_tax_data.dart';

class IncomeTaxData2018 extends IncomeTaxData{

  num PersonalAllowanceDefault = 11500;
  num StarterRateBand = 0;
  num BasicRateBand = 33500;
  num IntermediateRateBand = 0;
  num PersonalAllowanceTaperThreshold = 100000;
  num AdditionalRateLimit = 150000;

  num StarterRate= 0.20;
  num BasicRate = 0.2;
  num IntermediateRate = 0.20;
  num HigherRate = 0.4;
  num AdditionalRate = 0.45;

  num DividendNilBand = 5000;
  num DividendBasicRate = 0.075;
  num DividendHigherRate = 0.325;
  num DividendAdditionalRate = 0.381;
}
