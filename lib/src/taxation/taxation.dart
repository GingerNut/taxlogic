import '../tax_position/tax_position.dart';


abstract class Taxation{
  TaxPosition taxPosition;
  num tax = 0;

  Taxation(this.taxPosition);

  void calculate();

}