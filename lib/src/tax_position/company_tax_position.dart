import 'package:taxlogic/src/entities/entity.dart';
import 'tax_position.dart';


class CompanyTaxPosition extends TaxPosition{
  CompanyTaxPosition(Entity company) : super(company);

  @override
  num get basicRateAvailable => 0;
}