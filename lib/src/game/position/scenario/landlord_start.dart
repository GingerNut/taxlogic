import 'package:taxlogic/src/game/game.dart';
import '../position.dart';
import 'package:taxlogic/src/entities/individual/person.dart';
import 'package:taxlogic/src/activity/property_business.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/assets/property/residential_property.dart';
import '../../../accounts/rental_income_and_expenditure.dart';
import 'package:taxlogic/src/utilities/period.dart';
import '../../../accounts/income_and_expenditure.dart';
import 'scenario.dart';
import '../../game.dart';

class LandlordStart extends Scenario{
  Person person;

 LandlordStart();


  @override
  void setup(Game game){
    super.setup(game);

    person = new Person()
    ..name = name;

    game.position = new Position(game, null, null);
    game.position.addEntity(person);
    game.position.focussedEntity = person;
    PropertyBusiness business = new PropertyBusiness(person);

    ResidentialProperty property = new ResidentialProperty(person);
    business.properties.add(property);
    business.name = 'Property portfolio';

    property.changeRent(projectedIncome, start);
    property.changeInterest(projectedFinanceCost, start);

    Date enddate = new Date (5,4,start.taxYear);
    Period period = new Period(start, enddate);

    IncomeAndExpenditureProperty rentalAccounts = new IncomeAndExpenditureProperty(period, person);

    rentalAccounts.add(new IncomeAccount(enddate, 'rents', property.rent(period)));
    rentalAccounts.add(new Interest(enddate, 'interest', property.interest(period)));

    business.accounts.add(rentalAccounts);

  }




}