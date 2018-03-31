import '../tax_position/tax_position.dart';
import '../narrative/narrative.dart';

abstract class Taxation{
  TaxPosition taxPosition;

  Taxation(this.taxPosition);

  num get tax => calculate();

  num calculate();

  List<List<String>> narrative(List<List<String>> narrative);

}