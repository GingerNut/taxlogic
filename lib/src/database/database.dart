import 'package:taxlogic/src/entities/individual/person.dart';
import 'package:taxlogic/src/tax_position/personal/personal_tax_position.dart';



 abstract class TaxDatabase{

   List<Person> clients = new List();

   String clientList = 'clients';
   String staticDetails = 'static';
   String taxYears = "tax_years";

  savePerson(Person person);

  Person load (String code);

  savePosition(PersonalTaxPosition position);

   PersonalTaxPosition loadPosition(Person person, int year);

   refreshClients();

}