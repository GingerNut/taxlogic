import 'package:taxlogic/src/entities/person.dart';
import '../assets/chargeable_assets.dart';
import '../utilities.dart';
import '../tax_position/personal_tax_position.dart';
import 'capital_gains.dart';
import '../data/tax_data.dart';

class CompanyCapitalGainsPosition extends CapitalGains{

  CompanyCapitalGainsPosition(Person person, PersonalTaxPosition taxPosition) : super(person, taxPosition);

  void allocateLosses(){

  }

  void calculateTax() {


    tax = Utilities.roundTax(tax);
  }
}