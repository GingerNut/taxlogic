
import 'package:taxlogic/src/residence/domicile_history.dart';

import 'package:taxlogic/src/utilities/history/spouse_history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';
import 'package:taxlogic/src/tax_position/personal/personal_tax_position.dart';

import '../entity.dart';

class Person extends Entity{

  static const String jsonTagCode = "code";
  static const String jsonTagScotland = "scotland";
  static const String jsonTagFirstName = "first_name";
  static const String jsonTagSurname = "surname";
  static const String jsonTagAddress = "address";

  DomicileHistory domicile;
  bool scotland = false;
  SpouseHistory spouse;

  String firstName;
  String surname;
  String address;

  PersonalTaxPosition currentTaxYear;

  Person(){
    type = Entity.INDIVIDUAL;
  }

  PersonalTaxPosition taxYear(int year){

    PersonalTaxPosition taxYear;

    taxPeriods.forEach((taxPosition){
      if(taxPosition.period.end.year == year) taxYear = taxPosition;
    });

    if(taxYear == null){
      taxYear = new PersonalTaxPosition(this, year);
      taxPeriods.add(taxYear);
    }

    taxYear.tax;

    return taxYear;
  }

  setCurrentTaxYear(int year) {
    currentTaxYear = taxYear(year);
  }



    static Person fromMap(Map map){

      Person person = new Person();
      person.code = map[jsonTagCode];
      person.scotland = map[jsonTagScotland] == 'true';
      person.firstName = map[jsonTagFirstName];
      person.surname = map[jsonTagSurname];
      person.address = map[jsonTagAddress];

      return person;
    }

    Map toMap(){

      Map jsonMap = {
        jsonTagCode: code,
        jsonTagFirstName: firstName,
        jsonTagSurname: surname,
        jsonTagAddress: address
      };



      return jsonMap;
    }

    @override
  num taxPayble(int taxYearEnd) {

    return  taxYear(taxYearEnd).tax;
  }

  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }
}

