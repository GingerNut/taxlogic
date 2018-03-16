import '../tax_position/tax_position.dart';
import '../entities/entity.dart';

abstract class CapitalGainsBase{
  Entity person;
  TaxPosition taxPosition;

  num capitalLossesBroughtForward = 0;
  num capitalLossesCarriedForward = 0;
  num totalGains;
  num annualExemption;
  num basicRateAmount = 0;
  num capitalLosses;
  num netGains = 0;
  num capitalGainsTax = 0;
  num taxableGains = 0;

  num tax = 0;

  CapitalGainsBase(this.person, this.taxPosition);

  void calculate();

}