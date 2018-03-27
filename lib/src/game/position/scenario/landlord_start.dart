import 'package:taxlogic/src/game/game.dart';
import '../position.dart';
import '../../../entities/person.dart';
import '../../../assets/property_business.dart';
import '../../../date.dart';
import '../../../assets/residential_property.dart';
import '../../../accounts/rental_income_and_expenditure.dart';
import '../../../period.dart';
import '../../../accounts/income_and_expenditure.dart';
import 'scenario.dart';
import '../../../entities/person.dart';
import '../../../tax_year.dart';

class LandlordStart extends Position{
  Scenario scenario;

  LandlordStart(Game game, this.scenario) : super(game, null, null);




  @override
  setUp() {
    Person person;
    entity = new Person();
    PropertyBusiness business = new PropertyBusiness(entity);
    person = entity as Person;

    person.assets.add(business);
    int taxYear = scenario.start.taxYear;

    ResidentialProperty property = new ResidentialProperty(entity);
    business.properties.add(property);


    Date startDate = new Date(6,4,taxYear-1);
    Date enddate = new Date (5,4,taxYear);
    Period period = new Period(startDate,enddate);

    IncomeAndExpenditureProperty rentalAccounts = new IncomeAndExpenditureProperty(period, entity);

    rentalAccounts.add(new Income(new Date(5,4,taxYear), 'rents', property.rent(period)));
    rentalAccounts.add(new Interest(new Date(5,4,taxYear), 'interest', property.interest(period)));

    business.accounts.add(rentalAccounts);
    person.taxYear(taxYear).incomeTaxPosition.calculate();

  }




}