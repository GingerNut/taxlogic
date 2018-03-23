import 'package:taxlogic/src/game/game.dart';
import 'position.dart';
import '../../entities/person.dart';
import '../../assets/property_business.dart';
import '../../date.dart';
import '../../assets/residential_property.dart';
import '../../accounts/rental_income_and_expenditure.dart';
import '../../period.dart';
import '../../accounts/income_and_expenditure.dart';


class LandlordStart extends Position{
  Date start;
  Person person;
  int taxYear;

  LandlordStart(Game game, this.start) : super(game, null, null);

  PropertyBusiness business;


  @override
  setUp() {
    entity = new Person();
    business = new PropertyBusiness(entity);
    person = entity as Person;

    person.assets.add(business);
    taxYear = start.taxYear;

    ResidentialProperty property = new ResidentialProperty(entity);
    business.properties.add(property);

    property.annualRent = 10000;
    property.annualInterest = 5000;

    Date startDate = new Date(6,4,taxYear-1);
    Date enddate = new Date (5,4,taxYear);
    Period period = new Period(startDate,enddate);

    IncomeAndExpenditureProperty rentalAccounts = new IncomeAndExpenditureProperty(period, entity);

    rentalAccounts.add(new Income(new Date(5,4,taxYear), 'rents', property.annualRent));
    rentalAccounts.add(new Interest(new Date(5,4,taxYear), 'interest', property.annualInterest));

    print('printing from landlord start - property interest calcs not right');

    print(rentalAccounts.profit);

    business.accounts.add(rentalAccounts);
    person.taxYear(taxYear).incomeTaxPosition.calculate();

    print(person.taxYear(taxYear).propertyIncome);
    print(person.taxYear(taxYear).incomeTaxPosition.tax);


  }




}