import 'package:taxlogic/src/entities/entity.dart';
import 'tax_position.dart';


class CompanyTaxPosition extends TaxPosition{
  CompanyTaxPosition(Entity person) : super(person);


  @override
  num get basicRateAvailable => 0;
}