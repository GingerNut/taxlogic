
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';



class CompanyTaxPosition extends TaxPosition{


  CompanyTaxPosition(Entity entity) : super (entity){

  }


  // TODO: implement tax
  @override
  num get tax => null;
}