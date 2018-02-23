import '../person.dart';
import '../tax_position.dart';


abstract class TaxDatabase{

  savePerson(Person person);

  Person load (String code);

  savePosition(TaxPosition position);

  TaxPosition loadPosition(Person person, int year);

}