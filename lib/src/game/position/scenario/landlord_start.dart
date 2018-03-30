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
import '../../game.dart';

class LandlordStart extends Scenario{
  Person person;

 LandlordStart();


  @override
  void setup(Game game){
    super.setup(game);

    person = new Person()
    ..name = 'landlord';

    game.position = new Position(game, null, null);
    game.position.addEntity(person);
    game.position.focussedEntity = person;
    PropertyBusiness business = new PropertyBusiness(person);

    person.activities.add(business);

    ResidentialProperty property = new ResidentialProperty(person);
    business.properties.add(property);

    property.setRent(projectedIncome, start);
    property.setInterst(projectedFinanceCost, start);

    Date enddate = new Date (5,4,start.taxYear);
    Period period = new Period(start, enddate);

    IncomeAndExpenditureProperty rentalAccounts = new IncomeAndExpenditureProperty(period, person);

    rentalAccounts.add(new Income(enddate, 'rents', property.rent(period)));
    rentalAccounts.add(new Interest(enddate, 'interest', property.interest(period)));

    business.accounts.add(rentalAccounts);

  }




}