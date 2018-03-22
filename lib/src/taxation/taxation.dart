import '../tax_position/tax_position.dart';
import '../narrative/narrative.dart';

abstract class Taxation{
  TaxPosition taxPosition;
  num tax = 0;

  Taxation(this.taxPosition);

  void calculate();

  List<List<String>> narrative(List<List<String>> narrative);

}