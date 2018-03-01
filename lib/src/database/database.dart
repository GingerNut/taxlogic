import '../person.dart';
import '../tax_position.dart';



 abstract class TaxDatabase{

   List<Person> clients = new List();

   String clientList = 'clients';
   String staticDetails = 'static';
   String taxYears = "tax_years";

  savePerson(Person person);

  Person load (String code);

  savePosition(TaxPosition position);

  TaxPosition loadPosition(Person person, int year);

   refreshClients();

}